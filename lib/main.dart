import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twake_mobile/config/dimensions_config.dart';
import 'package:twake_mobile/config/styles_config.dart';
import 'package:twake_mobile/providers/companies_provider.dart';
import 'package:twake_mobile/providers/init_provider.dart';
import 'package:twake_mobile/providers/user_provider.dart';
import 'package:twake_mobile/screens/auth_screen.dart';
import 'package:twake_mobile/screens/companies_list_screen.dart';
import 'package:twake_mobile/screens/workspaces_screen.dart';
import 'package:twake_mobile/services/twake_api.dart';

void main() {
  runApp(TwakeMobileApp());
}

class TwakeMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TwakeApi>(
          create: (ctx) => TwakeApi(),
        ),
        ChangeNotifierProxyProvider<TwakeApi, InitProvider>(
          create: (ctx) {
            return InitProvider();
          },
          update: (ctx, api, init) => init..init(api),
        ),
        ChangeNotifierProxyProvider<InitProvider, UserProvider>(
          create: (ctx) {
            return UserProvider();
          },
          update: (ctx, init, user) => user..loadUser(init.userData),
        ),
        ChangeNotifierProxyProvider<InitProvider, CompaniesProvider>(
            create: (ctx) {
          return CompaniesProvider();
        }, update: (ctx, init, companies) {
          final c = init.companies;
          return companies..loadCompanies(c);
        }),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) => OrientationBuilder(
          builder: (context, orientation) {
            /// Here we initialize the size configuration, to get access
            /// to scaling multipliers accross the rest of the app.
            /// If screen orientation changes, OrientationBuilder will reinitialize
            /// the configuration again, so other widgets can make use
            /// of new values.
            DimensionsConfig().init(constraints, orientation);
            final api = Provider.of<TwakeApi>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Twake',
              theme: StylesConfig.lightTheme,
              home: api.isAuthorized ? CompaniesListScreen() : AuthScreen(),
              routes: {
                AuthScreen.route: (BuildContext _) => AuthScreen(),
                CompaniesListScreen.route: (BuildContext _) =>
                    CompaniesListScreen(),
                WorkspacesScreen.route: (BuildContext _) => WorkspacesScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}

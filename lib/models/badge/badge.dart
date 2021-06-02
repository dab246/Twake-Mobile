import 'package:json_annotation/json_annotation.dart';
import 'package:twake/models/base_model/base_model.dart';

part 'badge.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Badge extends BaseModel {
  final BadgeType type;
  final String id;
  final int count;

  const Badge({
    required this.type,
    required this.id,
    required this.count,
  });

  factory Badge.fromJson({required Map<String, dynamic> json}) {
    return _$BadgeFromJson(json);
  }

  @override
  Map<String, dynamic> toJson({bool stringify: false}) {
    return _$BadgeToJson(this);
  }

  bool matches({required BadgeType type, required String id}) {
    return type == type && id == id && count > 0;
  }
}

enum BadgeType {
  @JsonValue('company')
  company,
  @JsonValue('workspace')
  workspace,
  @JsonValue('channel')
  channel,
}

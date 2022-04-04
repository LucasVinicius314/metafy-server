import 'package:json_annotation/json_annotation.dart';

part 'common.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Info {
  String message;

  Info({
    required this.message,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

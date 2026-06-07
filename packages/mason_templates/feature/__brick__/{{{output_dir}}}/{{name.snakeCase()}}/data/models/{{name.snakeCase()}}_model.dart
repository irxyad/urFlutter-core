
// To parse this JSON data, do
//
//     final {{name.pascalCase()}}Model = {{name.pascalCase()}}ModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/{{name.snakeCase()}}_entity.dart';

part '{{name.snakeCase()}}_model.g.dart';

{{name.pascalCase()}}Model {{name.camelCase()}}ModelFromJson(String str) => {{name.pascalCase()}}Model.fromJson(json.decode(str)  as Map<String, dynamic>);

String {{name.camelCase()}}ModelToJson({{name.pascalCase()}}Model data) => json.encode(data.toJson());

@JsonSerializable()
class {{name.pascalCase()}}Model {
    @JsonKey(name: "id")
    int id;

    {{name.pascalCase()}}Model({
        required this.id,
    });

    factory {{name.pascalCase()}}Model.fromEntity({{name.pascalCase()}}Entity entity) => {{name.pascalCase()}}Model(
    id: entity.id,
    );

    factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) => _${{name.pascalCase()}}ModelFromJson(json);

    Map<String, dynamic> toJson() => _${{name.pascalCase()}}ModelToJson(this);

    {{name.pascalCase()}}Entity toEntity() => {{name.pascalCase()}}Entity(
      id: id,
    );
}

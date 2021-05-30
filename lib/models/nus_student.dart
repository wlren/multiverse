/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs
// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/// This is an auto generated class representing the NUSStudent type in your schema. */
@immutable
class NUSStudent extends Model {
  static const classType = _NUSStudentModelType();
  @override
  // ignore: overridden_fields
  final String id;
  final String? email;
  final String? matricNo;
  final String nusNetID;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const NUSStudent._internal(
      {required this.id, this.email, this.matricNo, required this.nusNetID});

  factory NUSStudent(
      {String? id, String? email, String? matricNo, required String nusNetID}) {
    return NUSStudent._internal(
        id: id ?? UUID.getUUID(),
        email: email,
        matricNo: matricNo,
        nusNetID: nusNetID);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NUSStudent &&
        id == other.id &&
        email == other.email &&
        matricNo == other.matricNo &&
        nusNetID == other.nusNetID;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = StringBuffer();

    buffer.write("NUSStudent {");
    buffer.write("id=" + id + ", ");
    buffer.write("email=" + email! + ", ");
    buffer.write("matric_no=" + matricNo! + ", ");
    buffer.write("nusNetID=" + nusNetID);
    buffer.write("}");

    return buffer.toString();
  }

  NUSStudent copyWith(
      {String? id, String? email, String? matricNo, String? nusNetID}) {
    return NUSStudent(
        id: id ?? this.id,
        email: email ?? this.email,
        matricNo: matricNo ?? this.matricNo,
        nusNetID: nusNetID ?? this.nusNetID);
  }

  NUSStudent.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        email = json['email'] as String,
        matricNo = json['matricNo'] as String,
        nusNetID = json['nusNetID'] as String;

  @override
  Map<String, dynamic> toJson() =>
      {'id': id, 'email': email, 'matric_no': matricNo, 'nusNetID': nusNetID};

  // ignore: constant_identifier_names
  static const QueryField ID = QueryField(fieldName: "nUSStudent.id");
  // ignore: constant_identifier_names
  static const QueryField EMAIL = QueryField(fieldName: "email");
  // ignore: constant_identifier_names
  static const QueryField MATRIC_NO = QueryField(fieldName: "matric_no");
  // ignore: constant_identifier_names
  static const QueryField NUSNETID = QueryField(fieldName: "nusNetID");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "NUSStudent";
    modelSchemaDefinition.pluralName = "NUSStudents";

    modelSchemaDefinition.authRules = [
      const AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: NUSStudent.EMAIL,
        isRequired: false,
        ofType: const ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: NUSStudent.MATRIC_NO,
        isRequired: false,
        ofType: const ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: NUSStudent.NUSNETID,
        isRequired: true,
        ofType: const ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class _NUSStudentModelType extends ModelType<NUSStudent> {
  const _NUSStudentModelType();

  @override
  NUSStudent fromJson(Map<String, dynamic> jsonData) {
    return NUSStudent.fromJson(jsonData);
  }
}

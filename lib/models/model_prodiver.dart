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
import 'nus_student.dart';

export 'nus_student.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "8676c599f223170c6048166896e7d268";
  @override
  List<ModelSchema> modelSchemas = [NUSStudent.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;

  @override
  ModelType getModelTypeByModelName(String modelName) {
    switch (modelName) {
      case "NUSStudent":
        {
          return NUSStudent.classType;
        }
      default:
        {
          throw Exception(
              "Failed to find model in model provider for model name: " +
                  modelName);
        }
    }
  }
}

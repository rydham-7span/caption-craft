import 'dart:io';

import 'package:hive/hive.dart';

part 'save_data_model.g.dart';

@HiveType(typeId: 0)
class SaveDataModel extends HiveObject {

  @HiveField(0)
  File? image;

  @HiveField(1)
  String? caption;

  SaveDataModel({this.image, this.caption});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'caption': caption,
    };
  }

  factory SaveDataModel.fromMap(Map<String, dynamic> map) {
    return SaveDataModel(
      image: map['image'] as File,
      caption: map['caption'] as String,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'save_data_model.g.dart';

@HiveType(typeId: 0)
class SaveDataModel extends HiveObject {
  @HiveField(0)
  Uint8List? image;

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
      image: map['image'] as Uint8List?,
      caption: map['caption'] as String?,
    );
  }

  SaveDataModel copyWith({
    Uint8List? image,
    String? caption,
  }) {
    return SaveDataModel(
      image: image ?? this.image,
      caption: caption ?? this.caption,
    );
  }
}

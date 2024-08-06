import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'save_data_model.g.dart';

@HiveType(typeId: 0)
class SaveDataModel extends HiveObject {
  @HiveField(0)
  Uint8List? image;

  @HiveField(1)
  String? caption;

  @HiveField(3)
  String? type;

  SaveDataModel({this.image, this.caption, this.type});

  SaveDataModel copyWith({
    Uint8List? image,
    String? caption,
    String? type,
  }) {
    return SaveDataModel(
      image: image ?? this.image,
      caption: caption ?? this.caption,
      type: type ?? this.type,
    );
  }
}

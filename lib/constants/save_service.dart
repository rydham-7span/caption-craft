import 'package:caption_this/constants/enum.dart';
import 'package:caption_this/home/model/save_data_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ISaveService {
  Future<Unit> init();

  List<SaveDataModel> getUserData();

  TaskEither<String, Unit> setUserData(SaveDataModel saveDataModel);

  Task<Unit> deleteUserData(int index);
}

class SaveService extends ISaveService {
  @override
  Future<Unit> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SaveDataModelAdapter());
    await Hive.openBox<SaveDataModel>(SAVEDBOX.data.value);
    return unit;
  }

  @override
  TaskEither<String, Unit> setUserData(SaveDataModel saveDataModel) => TaskEither.tryCatch(
        () async {
          final box = Hive.box<SaveDataModel>(SAVEDBOX.data.value);
          await box.add(saveDataModel);
          await saveDataModel.save();
          return unit;
        },
        (error, stackTrace) => 'Something Went Wrong.${error.toString()}',
      );

  @override
  List<SaveDataModel> getUserData() {
    final box = Hive.box<SaveDataModel>(SAVEDBOX.data.value);
    final data = box.values.toList();
    return data;
  }

  @override
  Task<Unit> deleteUserData(int index) {
    return Task(
      () async {
        await Hive.box<SaveDataModel>(SAVEDBOX.data.value).deleteAt(index);
        return unit;
      },
    );
  }
}

import 'package:caption_craft/constants/enums/enum.dart';
import 'package:caption_craft/constants/hive/injection.dart';
import 'package:caption_craft/constants/hive/save_service.dart';
import 'package:caption_craft/constants/widgets/custom_snackbar.dart';
import 'package:caption_craft/home/bloc/generate_description_bloc.dart';
import 'package:caption_craft/home/model/save_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:share_plus/share_plus.dart';

class SavedDataScreen extends StatefulWidget {
  const SavedDataScreen({super.key});

  @override
  State<SavedDataScreen> createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends State<SavedDataScreen> {
  List<SaveDataModel> dataList = [];

  @override
  void initState() {
    dataList = getIt<ISaveService>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Saved',
          style: TextStyle(fontSize: 44, fontFamily: 'Danfo'),
        ),
      ),
      body: BlocListener<GenerateDescriptionBloc, GenerateDescriptionState>(
        listener: (context, state) {
          if (state.deleteDataEvent == ApiStatus.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                context: context,
                message: state.errorMessage ?? '',
              ),
            );
          }
        },
        child: PieCanvas(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: StatefulBuilder(
                builder: (context, stateList) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: dataList.isNotEmpty
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10, left: 10),
                                  child: Text(
                                    'Hold to copy or share.',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                ListView.builder(
                                  clipBehavior: Clip.none,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: dataList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PieMenu(
                                        theme: PieTheme(
                                          leftClickShowsMenu: true,
                                          rightClickShowsMenu: true,
                                          pointerColor: Colors.deepPurple.shade300,
                                          radius: 80,
                                          overlayColor: Colors.black.withAlpha(200),
                                        ),
                                        actions: [
                                          PieAction(
                                            buttonTheme: const PieButtonTheme(
                                              backgroundColor: Colors.deepPurple,
                                              iconColor: Colors.white,
                                            ),
                                            buttonThemeHovered: const PieButtonTheme(
                                              backgroundColor: Colors.deepPurple,
                                              iconColor: Colors.white,
                                            ),
                                            tooltip: const Text(
                                              'Copy',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            onSelect: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(text: dataList[index].caption ?? ''));
                                            },
                                            child: const Icon(Icons.copy_all_rounded),
                                          ),
                                          if (!kIsWeb)
                                            PieAction(
                                              buttonTheme: const PieButtonTheme(
                                                backgroundColor: Colors.deepPurple,
                                                iconColor: Colors.white,
                                              ),
                                              tooltip: const Text(
                                                'Share',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              buttonThemeHovered: const PieButtonTheme(
                                                backgroundColor: Colors.deepPurple,
                                                iconColor: Colors.white,
                                              ),
                                              onSelect: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(text: dataList[index].caption ?? ''));
                                                await Share.shareXFiles(
                                                  [
                                                    XFile.fromData(
                                                      dataList[index].image ?? Uint8List(0),
                                                      mimeType:
                                                          lookupMimeType('', headerBytes: dataList[index].image) ??
                                                              'image/jpeg',
                                                    )
                                                  ],
                                                  text: dataList[index].caption,
                                                );
                                              },
                                              child: const Icon(
                                                Icons.share,
                                                color: Colors.white,
                                              ),
                                            ),
                                          PieAction(
                                            buttonTheme: const PieButtonTheme(
                                              backgroundColor: Colors.deepPurple,
                                              iconColor: Colors.white,
                                            ),
                                            tooltip: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            buttonThemeHovered: const PieButtonTheme(
                                              backgroundColor: Colors.deepPurple,
                                              iconColor: Colors.white,
                                            ),
                                            onSelect: () {
                                              dataList.removeAt(index);
                                              stateList(() {});
                                              context
                                                  .read<GenerateDescriptionBloc>()
                                                  .add(DeleteDataEvent(index: index));
                                            },
                                            child: const Icon(
                                              CupertinoIcons.trash,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                        child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            if (constraints.maxWidth < 480) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 10,
                                                      color: Colors.deepPurple,
                                                      offset: Offset(0, 5),
                                                    )
                                                  ],
                                                  color: Colors.grey.shade900,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.memory(
                                                          dataList[index].image ?? Uint8List(0),
                                                          width: double.infinity,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return const SizedBox.shrink();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        dataList[index].type ?? '',
                                                        style:
                                                            const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                                      child: Text(
                                                        dataList[index].caption ?? '',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 10,
                                                      color: Colors.deepPurple,
                                                      offset: Offset(0, 5),
                                                    )
                                                  ],
                                                  color: Colors.grey.shade900,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: Image.memory(
                                                            dataList[index].image ?? Uint8List(0),
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) {
                                                              return const SizedBox.shrink();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 7,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              dataList[index].type ?? '',
                                                              style: const TextStyle(
                                                                  fontSize: 21, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                                            child: Text(
                                                              dataList[index].caption ?? '',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Lottie.asset(
                                'assets/lottie/no_data.json',
                                height: 400,
                                width: double.maxFinite
                              ),
                              const SizedBox(
                                width: 200,
                                child: Text(
                                  'Your saved crafts will be available here.',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

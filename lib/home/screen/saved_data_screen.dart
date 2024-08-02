import 'package:caption_this/constants/injection.dart';
import 'package:caption_this/constants/save_service.dart';
import 'package:caption_this/home/model/save_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      body: PieCanvas(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: dataList.isNotEmpty
                  ? ListView.builder(
                clipBehavior: Clip.none,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieMenu(
                            theme: PieTheme(
                              // delayDuration: Duration.zero,
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
                                  await Clipboard.setData(ClipboardData(text: dataList[index].caption ?? ''));
                                },
                                child: const Icon(Icons.copy_all_rounded),
                              ),
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
                                  await Clipboard.setData(ClipboardData(text: dataList[index].caption ?? ''));
                                  await Share.shareXFiles(
                                    [XFile.fromData(dataList[index].image ?? Uint8List(0))],
                                    text: dataList[index].caption,
                                  );
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.shareNodes,
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
                                onSelect: () async {
                                  getIt<ISaveService>().deleteUserData(index).run();
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            child: Container(
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
                                    padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                                    child: Text(
                                      dataList[index].caption ?? '',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('Start generating & saving...',style: TextStyle(fontSize: 18),)),
            ),
          ),
        ),
      ),
    );
  }
}

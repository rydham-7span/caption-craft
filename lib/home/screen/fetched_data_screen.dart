import 'package:caption_craft/constants/enums/enum.dart';
import 'package:caption_craft/constants/widgets/custom_snackbar.dart';
import 'package:caption_craft/home/bloc/generate_description_bloc.dart';
import 'package:caption_craft/home/model/save_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:share_plus/share_plus.dart';

class FetchedDataScreen extends StatefulWidget {
  const FetchedDataScreen({super.key, required this.controller});

  final LiquidController controller;

  @override
  State<FetchedDataScreen> createState() => _FetchedDataScreenState();
}

class _FetchedDataScreenState extends State<FetchedDataScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final responseList = <String>[];
  final mediaList = <String>['LinkedIn:', 'Instagram:', 'X:'];
  final saveDataModel = SaveDataModel();

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )
      ..forward()
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PieCanvas(
        theme: PieTheme(
          rightClickShowsMenu: true,
          pointerColor: Colors.deepPurple.shade300,
          radius: 80,
          overlayColor: Colors.black.withAlpha(200),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: BlocConsumer<GenerateDescriptionBloc, GenerateDescriptionState>(
              listenWhen: (previous, current) =>
                  (previous.fetchDetailsState, previous.saveDetailsState) !=
                  (current.fetchDetailsState, current.saveDetailsState),
              listener: (context, state) {
                if (state.saveDetailsState == ApiStatus.loaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context: context,
                      message: state.errorMessage ?? '',
                    ),
                  );
                } else if (state.fetchDetailsState == ApiStatus.loaded) {
                  final dataList = state.response?.split('********');
                  for (int i = 0; i < (3); i++) {
                    responseList.add(dataList?[i].trim().replaceAll(mediaList[i], '').trim() ?? '');
                  }
                }
              },
              builder: (context, state) {
                if (state.fetchDetailsState == ApiStatus.loaded) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'STEP : 3',
                              style: TextStyle(fontSize: 54, fontFamily: 'Danfo'),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),
                            child: Text(
                              'Just tap & hold to share or save',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: responseList.isNotEmpty
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: mediaList.length,
                                      itemBuilder: (context, index) {
                                        return PieMenu(
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
                                                HapticFeedback.lightImpact();
                                                await Clipboard.setData(ClipboardData(text: responseList[index]));
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
                                                HapticFeedback.lightImpact();
                                                await Clipboard.setData(ClipboardData(text: responseList[index]));
                                                await Share.shareXFiles(
                                                  [
                                                    XFile.fromData(
                                                      state.image ?? Uint8List(0),
                                                      mimeType:
                                                          lookupMimeType('', headerBytes: state.image) ?? 'image/jpeg',
                                                    )
                                                  ],
                                                  text: responseList[index],
                                                );
                                              },
                                              child: const Icon(Icons.share),
                                            ),
                                            PieAction(
                                              buttonTheme: const PieButtonTheme(
                                                backgroundColor: Colors.deepPurple,
                                                iconColor: Colors.white,
                                              ),
                                              tooltip: const Text(
                                                'Save',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              buttonThemeHovered: const PieButtonTheme(
                                                backgroundColor: Colors.deepPurple,
                                                iconColor: Colors.white,
                                              ),
                                              onSelect: () async {
                                                HapticFeedback.lightImpact();
                                                context.read<GenerateDescriptionBloc>().add(
                                                      SaveDataEvent(
                                                        saveDataModel: saveDataModel.copyWith(
                                                          image: state.image,
                                                          caption: responseList[index],
                                                          type: mediaList[index].split(':').first,
                                                        ),
                                                      ),
                                                    );
                                              },
                                              child: const Icon(CupertinoIcons.bookmark_fill),
                                            ),
                                          ],
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  mediaList[index],
                                                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10),
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
                                                  child: SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        responseList[index],
                                                        style: const TextStyle(fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink()),
                          Flexible(
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    int nextPage = widget.controller.currentPage - 1;
                                    widget.controller.animateToPage(page: nextPage);
                                    responseList.clear();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.minPositive, 46),
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text(
                                    'Recraft',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    int nextPage = widget.controller.currentPage + 1;
                                    widget.controller.animateToPage(page: nextPage);
                                    context.read<GenerateDescriptionBloc>().add(RemoveImageEvent());
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(double.minPositive, 46),
                                    side: const BorderSide(color: Colors.deepPurple, width: 4),
                                  ),
                                  child: const Text(
                                    'Generate New',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state.fetchDetailsState == ApiStatus.error) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Lottie.asset(
                          'assets/lottie/error.json',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          int nextPage = 0;
                          widget.controller.animateToPage(page: nextPage);
                          context.read<GenerateDescriptionBloc>().add(RemoveImageEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 46),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/loading.json',
                      controller: animationController,
                      height: 300,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:caption_this/constants/enum.dart';
import 'package:caption_this/constants/injection.dart';
import 'package:caption_this/constants/save_service.dart';
import 'package:caption_this/home/bloc/generate_description_bloc.dart';
import 'package:caption_this/home/model/save_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
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
          delayDuration: Duration.zero,
          rightClickShowsMenu: true,
          pointerColor: Colors.deepPurple.shade300,
          radius: 80,
          overlayColor: Colors.black.withAlpha(200),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: BlocConsumer<GenerateDescriptionBloc, GenerateDescriptionState>(
              listener: (context, state) {
                if (state.fetchDetailsState == ApiStatus.loaded) {
                  final dataList = state.response?.split('********\n');

                  for (int i = 0; i < (3); i++) {
                    responseList.add(dataList?[i].trim().replaceAll(mediaList[i], '').trim() ?? '');
                  }
                }
              },
              builder: (context, state) {
                if (state.fetchDetailsState == ApiStatus.loaded) {
                  return Padding(
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
                            'Just Tap & Share',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.66,
                            child: ListView.builder(
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
                                        await Clipboard.setData(ClipboardData(text: responseList[index]));
                                        await Share.shareXFiles(
                                          [XFile.fromData(state.image ?? Uint8List(0))],
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
                                        await getIt<ISaveService>()
                                            .setUserData(saveDataModel.copyWith(
                                              image: state.image,
                                              caption: responseList[index],
                                            ))
                                            .run();
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                int nextPage = widget.controller.currentPage - 1;
                                widget.controller.animateToPage(page: nextPage);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Go Back',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                int nextPage = 0;
                                widget.controller.animateToPage(page: nextPage);
                                context.read<GenerateDescriptionBloc>().add(RemoveImageEvent());
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Generate New',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                          minimumSize: const Size(200,46),
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

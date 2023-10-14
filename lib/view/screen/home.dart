import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:islamic_songs/controller/controller.dart';
import 'package:islamic_songs/data/datasource/static/colors.dart';
import 'package:islamic_songs/view/widget/home/controlbuttons.dart';
import 'package:islamic_songs/view/widget/home/list_of_songs.dart';
import 'package:islamic_songs/view/widget/home/loop_row.dart';
import 'package:islamic_songs/view/widget/home/seek_bar_widget.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyController controller = Get.put(MyController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  expandedHeight: (80.h),
                  flexibleSpace: FlexibleSpaceBar(
                    background: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset(
                        'assets/1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: const Text("أناشيد أسلامية"),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const ListOfSongs(),
                  ]),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: (160.h),
                color: AppColor.secondaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      LoopRow(controller: controller),
                      SeekBarWdget(controller: controller),
                      SizedBox(height: 1.0.h),
                      ControlButtons(controller.player),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

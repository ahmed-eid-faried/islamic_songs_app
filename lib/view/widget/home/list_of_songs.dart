import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:islamic_songs/controller/controller.dart';
import 'package:islamic_songs/data/datasource/static/colors.dart';

class ListOfSongs extends StatelessWidget {
  const ListOfSongs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyController controller = Get.put(MyController());
    return Container(
      color: AppColor.background,
      height: 420.h,
      child: StreamBuilder<SequenceState?>(
        stream: controller.player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];
          return ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex--;
              controller.kplaylist.move(oldIndex, newIndex);
            },
            children: [
              for (var i = 0; i < sequence.length; i++)
                Dismissible(
                    key: ValueKey(sequence[i]),
                    background: Container(
                      color: AppColor.primaryColor,
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 2.0.h),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (dismissDirection) {
                      controller.kplaylist.removeAt(i);
                    },
                    child: Material(
                      color:
                          i == state!.currentIndex ? AppColor.background : null,
                      child: ListTile(
                        tileColor: AppColor.background,
                        title: Center(
                            child: Text(sequence[i].tag.title as String)),
                        onTap: () {
                          controller.player.seek(Duration.zero, index: i);
                        },
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }
}

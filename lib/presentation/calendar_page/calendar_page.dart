import 'package:flutter/material.dart';
import 'package:pengingat_list/common/constants.dart';
import 'package:pengingat_list/common/text_theme.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
            'https://png.pngtree.com/thumb_back/fh260/background/20220217/pngtree-aesthetic-landscape-illustration-background-image_946714.jpg',
            height: 320,
            width: Size.infinite.width,
            color: const Color.fromRGBO(255, 255, 255, 0.3),
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.fill),
        SizedBox(
          height: 350,
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1, DateTime.now().month,
                DateTime.now().day),
            lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
                DateTime.now().day),
            onDateChanged: (DateTime value) {},
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              Text(
                noTask,
                style: CustomTextTheme.ttCommons16Black,
              ),
              Text(
                addTasks,
                style: CustomTextTheme.ttCommons16Black,
              )
            ],
          ),
        )
      ],
    );
  }
}

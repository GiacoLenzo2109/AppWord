import 'package:app_word/res/custom_colors.dart';
import 'package:flutter/material.dart';

class BookItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  // ignore: use_key_in_widget_constructors
  const BookItemWidget({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(7.5),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {},
            splashColor: Colors.grey[200],
            child: ListTile(
              leading: Icon(icon),
              title: Text(title),
            ),
          ),
        )
      ],
    );
  }
}

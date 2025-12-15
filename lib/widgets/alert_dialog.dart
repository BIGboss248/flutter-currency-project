import 'package:flutter/material.dart';

/* 

# Choice dialog

*1. Assign a type to the future
!2. Future can be null if user presses out of the dialog borders dismissing the dialog

*/
Future<T?> showChoiceDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required List<Widget> actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: Text(content, textAlign: TextAlign.center),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actions,
        ),
      ],
    ),
  );
}

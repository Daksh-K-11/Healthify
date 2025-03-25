import 'package:flutter/material.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/core/widgets/animated_snackbar.dart';

void showSnackBar(BuildContext context, String content, bool isSuccess) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: AnimatedSnackBarContent(
          message: content,
          isSuccess: isSuccess,
        ),
      ),
    );
}

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Pallete.gradient1,
            onPrimary: Pallete.whiteColor,
            surface: Pallete.backgroundColor,
            onSurface: Pallete.whiteColor,
          ),
          dialogBackgroundColor: Pallete.backgroundColor,
        ),
        child: child!,
      );
    },
  );
}

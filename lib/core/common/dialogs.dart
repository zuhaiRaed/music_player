// ignore_for_file: constant_identifier_names, file_names

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/style.dart';

enum ActionStyle { normal, destructive, important, important_destructive }

class Dialogs {
  static const Color _normal = Colors.blue;
  static const Color _destructive = Colors.red;

  /// show the OS Native dialog
  static Future showOSDialog<T>({
    required BuildContext context,
    String? title,
    String? message,
    String? firstButtonText,
    Function? firstCallBack,
    ActionStyle firstActionStyle = ActionStyle.normal,
    String? secondButtonText,
    Function? secondCallback,
    ActionStyle secondActionStyle = ActionStyle.normal,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return _iosDialog<T>(
            context,
            title!,
            message!,
            firstButtonText!,
            firstCallBack,
            firstActionStyle: firstActionStyle,
            secondButtonText: secondButtonText,
            secondCallback: secondCallback,
            secondActionStyle: secondActionStyle,
          );
        } else {
          return _androidDialog<T>(
            context,
            title!,
            message!,
            firstButtonText,
            firstCallBack,
            firstActionStyle: firstActionStyle,
            secondButtonText: secondButtonText,
            secondCallback: secondCallback,
            secondActionStyle: secondActionStyle,
          );
        }
      },
    );
  }

  /// show the android Native dialog
  static Widget _androidDialog<T>(
    BuildContext context,
    String title,
    String message,
    String? firstButtonText,
    Function? firstCallBack, {
    ActionStyle? firstActionStyle = ActionStyle.normal,
    String? secondButtonText,
    Function? secondCallback,
    ActionStyle secondActionStyle = ActionStyle.normal,
  }) {
    final List<TextButton> actions = [];
    actions.add(
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          firstCallBack!();
        },
        child: Text(
          firstButtonText!,
          style: TextStyle(
            color: (firstActionStyle == ActionStyle.important_destructive ||
                    firstActionStyle == ActionStyle.destructive)
                ? _destructive
                : _normal,
            fontWeight:
                (firstActionStyle == ActionStyle.important_destructive ||
                        firstActionStyle == ActionStyle.important)
                    ? FontWeight.bold
                    : FontWeight.normal,
          ),
        ),
      ),
    );

    if (secondButtonText != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            secondCallback?.call();
          },
          child: Text(
            secondButtonText,
            style: TextStyle(
              color: (secondActionStyle == ActionStyle.important_destructive ||
                      firstActionStyle == ActionStyle.destructive)
                  ? _destructive
                  : _normal,
            ),
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData(useMaterial3: true),
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions,
        backgroundColor: Style.surfaceContainer,
      ),
    );
  }

  /// show the iOS Native dialog
  static Widget _iosDialog<T>(
    BuildContext context,
    String title,
    String message,
    String firstButtonText,
    Function? firstCallback, {
    ActionStyle firstActionStyle = ActionStyle.normal,
    String? secondButtonText,
    Function? secondCallback,
    ActionStyle secondActionStyle = ActionStyle.normal,
  }) {
    final List<CupertinoDialogAction> actions = [];
    actions.add(
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.of(context).pop();
          firstCallback!();
        },
        child: Text(
          firstButtonText,
          style: TextStyle(
            color: (firstActionStyle == ActionStyle.important_destructive ||
                    firstActionStyle == ActionStyle.destructive)
                ? _destructive
                : _normal,
            fontWeight:
                (firstActionStyle == ActionStyle.important_destructive ||
                        firstActionStyle == ActionStyle.important)
                    ? FontWeight.bold
                    : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );

    if (secondButtonText != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            secondCallback?.call();
          },
          child: Text(
            secondButtonText,
            style: TextStyle(
              color: (secondActionStyle == ActionStyle.important_destructive ||
                      secondActionStyle == ActionStyle.destructive)
                  ? _destructive
                  : _normal,
              fontWeight:
                  (secondActionStyle == ActionStyle.important_destructive ||
                          secondActionStyle == ActionStyle.important)
                      ? FontWeight.bold
                      : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions,
    );
  }
}

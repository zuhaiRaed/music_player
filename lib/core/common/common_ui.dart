import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../style/style.dart';
import '../../../core/application.dart';
import 'dialogs.dart';

mixin CommonUi {
  /// THIS METHOD USED TO CHECK IF THE INTERNET IS WORKING OR NOT, AND IF NOT THE PHONE SETTING WILL OPEN
  static bool checkInternetShown = false;

  static Future<void> checkInternet(BuildContext context) async {
    final isOnline = await Utils.isOnline();
    if (!isOnline && !checkInternetShown && context.mounted) {
      checkInternetShown = true;
      messageDialog(
        context,
        title: application.translate('noInternet'),
        message: application.translate('noInternetMsg'),
        onDismiss: () {
          checkInternetShown = false;
        },
        onConfirm: () {
          AppSettings.openAppSettings(type: AppSettingsType.wifi);
        },
      );
    }
  }
//

  /// THIS METHOD USED TO SHOW DIALOGS BASED ON OS PLATFORM
  static Future<void> messageDialog<T>(
    BuildContext context, {
    String title = '',
    String message = '',
    Function? onConfirm,
    Function? onDismiss,
    bool? withSecondButton = true,
    String? firstButtonText,
    String? secondButtonText,
    ActionStyle firstActionStyle = ActionStyle.normal,
    ActionStyle secondActionStyle = ActionStyle.normal,
  }) async {
    final _ = await Dialogs.showOSDialog<T>(
      context: context,
      title: title,
      message: message,
      firstActionStyle: firstActionStyle,
      secondActionStyle: secondActionStyle,
      firstButtonText: firstButtonText ?? application.translate('yes'),
      firstCallBack: () async {
        application.postDelayed(
          callbak: () {
            onConfirm?.call();
          },
        );
      },
      secondButtonText: withSecondButton == true
          ? secondButtonText ?? application.translate('no')
          : null,
    );
    if (onDismiss != null) {
      onDismiss();
    }
  }

  static snackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
    int? durationMilliSeconds,
    bool? showCloseIcon = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Style.mainFont.labelMedium
              ?.copyWith(color: textColor ?? Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ?? Style.surfaceContainer,
        showCloseIcon: showCloseIcon,
        closeIconColor: Style.secondary,
        duration: Duration(milliseconds: durationMilliSeconds ?? 3000),
        action: action,
      ),
    );
  }
}

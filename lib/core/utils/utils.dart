import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/common_ui.dart';
import '/core/application.dart';

void postDelayed({int milliseconds = 500, required VoidCallback callbak}) {
  Future.delayed(Duration(milliseconds: milliseconds), () {
    callbak();
  });
}

String toCamelCase(String str) {
  return str.toLowerCase().split(' ').asMap().entries.map((e) {
    return e.key == 0
        ? e.value
        : e.value.substring(0, 1).toUpperCase() + e.value.substring(1);
  }).join();
}

class Utils {
  static Future<bool> isOnline() async {
    var hasConnection = false;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    return hasConnection;
  }

  static dynamic getjsonFronStr(String str) {
    return json.decode(str);
  }

  static String parseUrl(String url) {
    if (url.startsWith('http://')) {
      url = 'https://${url.substring(7)}';
    } else if (!url.startsWith('https://')) {
      url = 'https://$url';
    }
    return Uri.parse(url).toString();
  }

  static Future<void> copyToClipboard(
    BuildContext context, {
    required String text,
  }) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    ).then(
      (value) => CommonUi.snackBar(
        context,
        application.translate('copiedMsg'),
      ),
    );
  }
}

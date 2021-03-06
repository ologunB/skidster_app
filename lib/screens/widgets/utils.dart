import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Utils {
  static void offKeyboard() async {
    await SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }

  static String googleMapKey = 'AIzaSyCJjJyC3Of4b4joSoyhtRYGxIvD_Tu7EAg';
  
  static String isValidPassword(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 5) {
      return 'Password not long enough';
    } else {
      return null;
    }
  }

  static String isValidName(String value) {
    if (value.isEmpty) {
      return 'Field cannot be Empty';
    }
    return null;
  }

  static String randomString({int no = 12}) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

    Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < no; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  static String validateEmail(String value) {
    value = value.trim();
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  static void unfocusKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      return;
    }
    currentFocus.unfocus();
  }

  static String conversationId(String from, String to) {
    String val = '';
    if (from.hashCode > to.hashCode) {
      val = from + to;
    } else {
      val = to + from;
    }
    return val;
  }

  static String last2(String a) {
    List<String> b = a.split(',').reversed.toList();
    int length = b.length;
    if (length > 3) {
      return b[2].trim() + ', ' + b[1].trim();
    } else if (length > 2) {
      return b[2].trim() + ', ' + b[1].trim();
    } else {
      return a;
    }
  }
}

extension customStringExtension on String {
  toTitleCase() {
    final words = this.toString().toLowerCase().split(' ');
    var newWord = '';
    for (var word in words) {
      if (word.isNotEmpty)
        newWord += '${word[0].toUpperCase()}${word.substring(1)} ';
    }

    return newWord;
  }

  getSingleInitial() {
    return this.split('')[0].toUpperCase();
  }

  sanitizeToDouble() {
    return double.tryParse(this.replaceAll(",", ""));
  }
}

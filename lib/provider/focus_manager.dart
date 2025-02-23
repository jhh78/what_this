import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/util/constants.dart';

class FocusManagerProvider extends GetxService {
  final FocusNode profileFocusNode = FocusNode();
  final FocusNode questionListFocusNode = FocusNode();
  final FocusNode commentFocusNode = FocusNode();
  final FocusNode myQuestionFocusNode = FocusNode();
  final FocusNode questionDetail = FocusNode();
  final FocusNode addQuestionFocusNode = FocusNode();

  void changeFocusNode(String route) {
    switch (route) {
      case USER_INFO:
        profileFocusNode.requestFocus();
        break;
      case QUESTION_LIST:
        questionListFocusNode.requestFocus();
        break;
      case MY_QUESTION:
        myQuestionFocusNode.requestFocus();
        break;
      case QUESTION_DETAIL:
        questionListFocusNode.requestFocus();
        break;
      case ADD_QUESTION:
        addQuestionFocusNode.requestFocus();
        break;
    }
  }
}

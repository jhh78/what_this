import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/util/constants.dart';

class FocusProvider extends GetxService {
  final FocusNode questionList = FocusNode();
  final FocusNode myQuestionList = FocusNode();
  final FocusNode questionDetail = FocusNode();
  final FocusNode addQuestion = FocusNode();

  void changeFocus(String screen) {
    switch (screen) {
      case QUESTION_LIST:
        questionList.requestFocus();
        break;
      case MY_QUESTION:
        myQuestionList.requestFocus();
        break;
      case QUESTION_DETAIL:
        questionDetail.requestFocus();
        break;
      case ADD_QUESTION:
        addQuestion.requestFocus();
        break;
    }
  }
}

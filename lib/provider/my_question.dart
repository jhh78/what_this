import 'dart:developer';

import 'package:get/get.dart';

class MyQuestionProvider extends GetxService {
  @override
  void onInit() {
    super.onInit();
    log('MyQuestionProvider onInit.');
  }

  @override
  void onClose() {
    super.onClose();
    log('MyQuestionProvider onClose.');
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/form.dart';
import 'package:whats_this/util/constants.dart';

class ReasonFormWidget extends StatelessWidget {
  ReasonFormWidget({super.key});

  final FormProvider formProvider = Get.put(FormProvider());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formProvider.formKey,
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '通報理由を選択してください';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: '理由を選択してください',
          border: OutlineInputBorder(),
        ),
        items: [
          DropdownMenuItem(
            value: 'スパム',
            child: Text('スパム'),
          ),
          DropdownMenuItem(
            value: '不適切な内容',
            child: Text('不適切な内容'),
          ),
          DropdownMenuItem(
            value: '暴力的な内容',
            child: Text('暴力的な内容'),
          ),
          DropdownMenuItem(
            value: '差別的な内容',
            child: Text('差別的な内容'),
          ),
          DropdownMenuItem(
            value: 'その他',
            child: Text('その他'),
          ),
        ],
        onChanged: (value) {
          formProvider.setData(REPORT_REASON_KIND, value.toString());
        },
      ),
    );
  }
}

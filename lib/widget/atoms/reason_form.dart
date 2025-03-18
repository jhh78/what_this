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
        validator: _validateReason,
        decoration: _inputDecoration(),
        items: _buildDropdownItems(),
        onChanged: (value) {
          formProvider.setData(REPORT_REASON_KIND, value.toString());
        },
      ),
    );
  }

  String? _validateReason(String? value) {
    if (value == null || value.isEmpty) {
      return '通報理由を選択してください';
    }
    return null;
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      hintText: '理由を選択してください',
      border: OutlineInputBorder(),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    const reasons = [
      'スパム',
      '不適切な内容',
      '暴力的な内容',
      '差別的な内容',
      'その他',
    ];

    return reasons
        .map((reason) => DropdownMenuItem(
              value: reason,
              child: Text(reason),
            ))
        .toList();
  }
}

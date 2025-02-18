import 'package:get/get.dart';
import 'package:whats_this/model/question.dart';

class CommentListProvider extends GetxService {
  Rxn<QuestionModel> questionModel = Rxn<QuestionModel>();

  void init() {
    questionModel.value = null;
  }

  void setQuestionModel(QuestionModel questionModel) {
    this.questionModel.value = questionModel;
  }
}

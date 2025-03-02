import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/model/user.dart';
import 'package:whats_this/util/util.dart';

class CommentModel {
  String id;
  QuestionModel question;
  UserModel user;
  String comment;
  int thumb_up;
  int thumb_down;
  String created;
  String updated;

  CommentModel({
    required this.id,
    required this.question,
    required this.user,
    required this.comment,
    required this.thumb_up,
    required this.thumb_down,
    required this.created,
    required this.updated,
  });

  factory CommentModel.emptyModel() {
    return CommentModel(
      id: '',
      question: QuestionModel.emptyModel(),
      user: UserModel.emptyModel(),
      comment: '',
      thumb_up: 0,
      thumb_down: 0,
      created: '',
      updated: '',
    );
  }

  factory CommentModel.fromRecordModel(RecordModel response) {
    return CommentModel(
      id: response.id,
      question: QuestionModel.emptyModel(),
      user: UserModel.fromJson(response.get('expand')['user']),
      comment: response.get('comment'),
      thumb_up: response.get('thumb_up'),
      thumb_down: response.get('thumb_down'),
      created: response.get('created'),
      updated: response.get('updated'),
    );
  }

  dynamic showData() {
    showLog({
      'id': id,
      'question': question.id,
      'user': user.id,
      'comment': comment,
      'thumb_up': thumb_up,
      'thumb_down': thumb_down,
      'created': created,
      'updated': updated,
    }, runtimeType);

    return "";
  }
}

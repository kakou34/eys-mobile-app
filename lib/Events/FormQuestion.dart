class FormQuestion {
  final String question;

  FormQuestion(this.question);

  factory FormQuestion.fromJson(Map<String, dynamic> json) {
    return FormQuestion(json['question']);
  }
}

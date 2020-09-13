class MessageResponse {
  final String message;
  final String messageType;
  MessageResponse({this.message, this.messageType});
  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      message: json['message'],
      messageType: json['messageType'],
    );
  }
}

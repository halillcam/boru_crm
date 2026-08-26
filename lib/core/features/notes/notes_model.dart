class NoteModel {
  final String id;
  final String customerId;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.customerId,
    required this.content,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertJson(String customerId) {
    return {'customer_id': customerId, 'content': content};
  }
}

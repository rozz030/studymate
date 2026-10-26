class StudyNote {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String priority;
  final DateTime? createdAt;

  const StudyNote({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    this.createdAt,
  });

  factory StudyNote.fromJson(Map<String, dynamic> json) {
    return StudyNote(
      id: json['id'] as int?,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'Medium',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
    };
  }
}

class Group {
  final String groupId;
  final String name;
  final String groupAdmin;
  final String? imageUrl;
  final String? description;
  final List<String> groupMembers;

  Group({
    required this.groupId,
    required this.name,
    required this.groupAdmin,
    this.imageUrl,
    this.description,
    this.groupMembers = const [],
  });

  Group.fromJson(Map<String, Object?> json)
      : this(
          groupId: json['groupId']! as String,
          name: json['name']! as String,
          groupAdmin: json['groupAdmin']! as String,
          imageUrl: json['imageUrl'] as String?,
          description: json['description'] as String?,
          groupMembers: (json['groupMembers'] as List<dynamic>).cast<String>(),
        );

  Map<String, Object?> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'groupAdmin': groupAdmin,
      'imageUrl': imageUrl,
      'description': description,
      'groupMembers': groupMembers,
    };
  }
}

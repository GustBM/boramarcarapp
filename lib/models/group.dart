class Group {
  final String groupId;
  final String name;
  final List<String> groupMembers;

  Group({
    required this.groupId,
    required this.name,
    this.groupMembers = const [],
  });

  Group.fromJason(Map<String, Object?> json)
      : this(
          groupId: json['groupId']! as String,
          name: json['name']! as String,
          groupMembers: json['groupMembers']! as List<String>,
        );

  Map<String, Object?> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'groupMembers': groupMembers,
    };
  }
}

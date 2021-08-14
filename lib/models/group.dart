class Group {
  final String groupId;
  final String name;
  final List<String> groupMembers;

  Group({
    required this.groupId,
    required this.name,
    this.groupMembers = const [],
  });
}

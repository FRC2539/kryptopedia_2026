class TeamMember {
  final String id;
  final String name;

  static const String tableName = "team_members";
  static const String idKey = "id";
  static const String nameKey = "name";

  TeamMember({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {idKey: id, nameKey: name};
  }

  TeamMember.fromMap(Map<String, dynamic> map)
    : id = map[idKey],
      name = map[nameKey];
}

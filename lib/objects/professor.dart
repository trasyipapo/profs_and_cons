class Professor {
  final String id;
  final String name;

  Professor({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  static Professor fromJson(Map<String, dynamic> json) =>
      Professor(id: json['id'], name: json['name']);
}

class Professor {
  int id;
  final String name;

  Professor({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

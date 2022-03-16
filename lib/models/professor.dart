// class Professor {
//   int professorId;
//   String firstName;

//   Professor.fromJson(Map json)
//       : professorId = int.parse(json['professor_id']),
//         firstName = json['first_name'];

//   Map toJson() {
//     return {'professor_id': professorId, 'first_name': firstName};
//   }
// }

class Professor {
  int id;
  String firstName;
  String lastName;
  double overallRating;

  Professor(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.overallRating});

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: int.parse(json['professor_id']),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      overallRating: double.parse(json['overall_ave']),
    );
  }
}

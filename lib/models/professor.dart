// class Professor {
//   int id;
//   String firstName;
//   String lastName;
//   double overallRating;
//   String department;

//   Professor(
//       {required this.id,
//       required this.firstName,
//       required this.lastName,
//       required this.overallRating,
//       required this.department});

//   factory Professor.fromJson(Map<String, dynamic> json) {
//     return Professor(
//       id: int.parse(json['professor_id']),
//       firstName: json['first_name'] as String,
//       lastName: json['last_name'] as String,
//       overallRating: double.parse(json['overall_ave']),
//       department: json['department'] as String,
//     );
//   }
// }

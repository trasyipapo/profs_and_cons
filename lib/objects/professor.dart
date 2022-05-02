class Professor {
  String? id;
  final String name;
  final String department;
  final String courses;
  final num overallRating;
  final num teachingRating;
  final num personalityRating;
  final num gradingRating;
  final num workloadRating;
  final num leniencyRating;
  final num attendanceRating;
  final num feedbackRating;

  Professor({
    this.id,
    required this.name,
    required this.department,
    required this.courses,
    this.overallRating = 0,
    this.teachingRating = 0,
    this.personalityRating = 0,
    this.gradingRating = 0,
    this.workloadRating = 0,
    this.leniencyRating = 0,
    this.attendanceRating = 0,
    this.feedbackRating = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'department': department,
        'courses': courses,
        'overallRating': overallRating,
        'teachingRating': teachingRating,
        'personalityRating': personalityRating,
        'gradingRating': gradingRating,
        'workloadRating': workloadRating,
        'leniencyRating': leniencyRating,
        'attendanceRating': attendanceRating,
        'feedbackRating': feedbackRating
      };

  static Professor fromJson(Map<String, dynamic> json) => Professor(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      courses: json['courses'],
      overallRating: json['overallRating'],
      teachingRating: json['teachingRating'],
      personalityRating: json['personalityRating'],
      gradingRating: json['gradingRating'],
      workloadRating: json['workloadRating'],
      leniencyRating: json['leniencyRating'],
      attendanceRating: json['attendanceRating'],
      feedbackRating: json['feedbackRating']);
}

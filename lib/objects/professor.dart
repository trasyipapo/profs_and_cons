class Professor {
  final String id;
  final String name;
  final String department;
  final String courses;
  final double overallRating;
  final double teachingRating;
  final double personalityRating;
  final double gradingRating;
  final double workloadRating;
  final double leniencyRating;
  final double attendanceRating;
  final double feedbackRating;

  Professor({
    required this.id,
    required this.name,
    required this.department,
    required this.courses,
    required this.overallRating,
    required this.teachingRating,
    required this.personalityRating,
    required this.gradingRating,
    required this.workloadRating,
    required this.leniencyRating,
    required this.attendanceRating,
    required this.feedbackRating,
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

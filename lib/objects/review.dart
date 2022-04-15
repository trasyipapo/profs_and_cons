class Review {
  final String id;
  final String courses;
  final double teachingRating;
  final double personalityRating;
  final double gradingRating;
  final double workloadRating;
  final double leniencyRating;
  final double attendanceRating;
  final double feedbackRating;
  final double overallRating;
  final String title;
  final String description;
  final String semesterTaken;
  final String yearTaken;
  final bool anonymous;

  Review({
    required this.id,
    required this.courses,
    required this.teachingRating,
    required this.personalityRating,
    required this.gradingRating,
    required this.workloadRating,
    required this.leniencyRating,
    required this.attendanceRating,
    required this.feedbackRating,
    required this.overallRating,
    required this.title,
    required this.description,
    required this.semesterTaken,
    required this.yearTaken,
    required this.anonymous,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courses': courses,
        'teachingRating': teachingRating,
        'personalityRating': personalityRating,
        'gradingRating': gradingRating,
        'workloadRating': workloadRating,
        'leniencyRating': leniencyRating,
        'attendanceRating': attendanceRating,
        'feedbackRating': feedbackRating,
        'overallRating': overallRating,
        'title': title,
        'description': description,
        'semesterTaken': semesterTaken,
        'yearTaken': yearTaken,
        'anonymous': anonymous
      };

  static Review fromJson(Map<String, dynamic> json) => Review(
      id: json['id'],
      courses: json['courses'],
      teachingRating: json['teachingRating'],
      personalityRating: json['personalityRating'],
      gradingRating: json['gradingRating'],
      workloadRating: json['workloadRating'],
      leniencyRating: json['leniencyRating'],
      attendanceRating: json['attendanceRating'],
      feedbackRating: json['feedbackRating'],
      overallRating: json['overallRating'],
      title: json['title'],
      description: json['description'],
      semesterTaken: json['semesterTaken'],
      yearTaken: json['yearTaken'],
      anonymous: json['anonymous']);
}

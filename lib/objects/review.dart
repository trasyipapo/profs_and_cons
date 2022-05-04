class Review {
  String? id;
  String? courses;
  double? teachingRating;
  double? personalityRating;
  double? gradingRating;
  double? workloadRating;
  double? leniencyRating;
  double? attendanceRating;
  double? feedbackRating;
  double? overallRating;
  String? title;
  String? description;
  String? semesterTaken;
  String? yearTaken;
  bool anonymous;
  String? profId;
  String? writer;
  String? writeruid;
  int votes;
  String? upvoters;
  String? downvoters;
  String? department;
  String? profName;

  Review({
    this.id,
    this.courses = "",
    this.teachingRating,
    this.personalityRating,
    this.gradingRating,
    this.workloadRating,
    this.leniencyRating,
    this.attendanceRating,
    this.feedbackRating,
    this.overallRating,
    this.title,
    this.description,
    this.semesterTaken,
    this.yearTaken,
    this.anonymous = false,
    this.profId,
    this.writer,
    this.writeruid,
    this.votes = 0,
    this.upvoters = "",
    this.downvoters = "",
    this.department,
    this.profName,
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
        'anonymous': anonymous,
        'profId': profId,
        'writer': writer,
        'writeruid': writeruid,
        'votes': votes,
        'upvoters': upvoters,
        'downvoters': downvoters,
        'profName': profName,
        'department': department,
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
        anonymous: json['anonymous'],
        profId: json['profId'],
        writer: json['writer'],
        writeruid: json['writeruid'],
        votes: json['votes'],
        upvoters: json['upvoters'],
        downvoters: json['downvoters'],
        profName: json['profName'],
        department: json['department'],
      );
}

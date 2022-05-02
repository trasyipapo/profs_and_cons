class Review {
  String? id;
  String? courses;
  num? teachingRating;
  num? personalityRating;
  num? gradingRating;
  num? workloadRating;
  num? leniencyRating;
  num? attendanceRating;
  num? feedbackRating;
  num? overallRating;
  String? title;
  String? description;
  String? semesterTaken;
  String? yearTaken;
  bool anonymous;
  String? profId;
  String? writer;
  String? writeruid;
  int votes;
  Map<String, bool>? voter = {};
  bool? isUp;

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
    this.isUp,
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
        'voter': voter,
        'isUp': isUp,
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
        isUp: json['isUp'],
        // voter: json['voter']
      );
}

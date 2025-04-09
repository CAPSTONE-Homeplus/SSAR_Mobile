class RatingRequest {
  String? serviceOrderId;
  int? rating;
  String? comments;

  RatingRequest({this.serviceOrderId, this.rating, this.comments});

  RatingRequest.fromJson(Map<String, dynamic> json) {
    serviceOrderId = json['serviceOrderId'];
    rating = json['rating'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceOrderId'] = this.serviceOrderId;
    data['rating'] = this.rating;
    data['comments'] = this.comments;
    return data;
  }
}

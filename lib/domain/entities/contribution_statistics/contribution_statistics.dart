class ContributionStatistics {
  int? totalContribution;
  String? timeFrame;
  List<Members>? members;

  ContributionStatistics(
      {this.totalContribution, this.timeFrame, this.members});

  ContributionStatistics.fromJson(Map<String, dynamic> json) {
    totalContribution = json['totalContribution'];
    timeFrame = json['timeFrame'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalContribution'] = this.totalContribution;
    data['timeFrame'] = this.timeFrame;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  String? name;
  int? contribution;
  int? percentage;

  Members({this.name, this.contribution, this.percentage});

  Members.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contribution = json['contribution'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contribution'] = this.contribution;
    data['percentage'] = this.percentage;
    return data;
  }
}
class ContributionStatisticsModel {
  int? totalContribution;
  String? timeFrame;
  List<MembersModel>? members;

  ContributionStatisticsModel(
      {this.totalContribution, this.timeFrame, this.members});

  ContributionStatisticsModel.fromJson(Map<String, dynamic> json) {
    totalContribution = json['totalContribution'];
    timeFrame = json['timeFrame'];
    if (json['members'] != null) {
      members = <MembersModel>[];
      json['members'].forEach((v) {
        members!.add(new MembersModel.fromJson(v));
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

class MembersModel {
  String? name;
  int? contribution;
  int? percentage;

  MembersModel({this.name, this.contribution, this.percentage});

  MembersModel.fromJson(Map<String, dynamic> json) {
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
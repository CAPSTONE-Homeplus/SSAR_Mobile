class ContributionStatistics {
  final int? totalContribution;
  final String? timeFrame;
  final List<Members>? members;

  ContributionStatistics({
    this.totalContribution,
    this.timeFrame,
    this.members,
  });

  factory ContributionStatistics.fromJson(Map<String, dynamic> json) {
    return ContributionStatistics(
      totalContribution: (json['totalContribution'] as num?)?.toInt(),
      timeFrame: json['timeFrame'] as String?,
      members: (json['members'] as List<dynamic>?)
          ?.map((v) => Members.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalContribution': totalContribution,
      'timeFrame': timeFrame,
      if (members != null) 'members': members!.map((v) => v.toJson()).toList(),
    };
  }
}

class Members {
  final String? name;
  final int? contribution;
  final double? percentage;

  Members({this.name, this.contribution, this.percentage});

  factory Members.fromJson(Map<String, dynamic> json) {
    return Members(
      name: json['name'] as String?,
      contribution: (json['contribution'] as num?)?.toInt(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contribution': contribution,
      'percentage': percentage,
    };
  }
}

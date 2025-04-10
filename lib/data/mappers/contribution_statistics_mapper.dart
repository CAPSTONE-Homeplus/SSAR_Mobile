import '../../domain/entities/contribution_statistics/contribution_statistics.dart';
import '../models/contribution_statistics/contribution_statistics_model.dart';

class ContributionStatisticsMapper {
  static ContributionStatistics toEntity(ContributionStatisticsModel model) {
    return ContributionStatistics(
      totalContribution: model.totalContribution,
      timeFrame: model.timeFrame,
      members: model.members?.map((e) => MembersMapper.toEntity(e)).toList(),
    );
  }

  static ContributionStatisticsModel toModel(ContributionStatistics entity) {
    return ContributionStatisticsModel(
      totalContribution: entity.totalContribution,
      timeFrame: entity.timeFrame,
      members: entity.members?.map((e) => MembersMapper.toModel(e)).toList(),
    );
  }
}

class MembersMapper {
  static Members toEntity(MembersModel model) {
    return Members(
      name: model.name,
      contribution: model.contribution,
      percentage: model.percentage,
    );
  }

  static MembersModel toModel(Members entity) {
    return MembersModel(
      name: entity.name,
      contribution: entity.contribution,
      percentage: entity.percentage,
    );
  }
}

import 'package:equatable/equatable.dart';

class RefreshToken extends Equatable{
  String? userId;
  String? refreshToken;

  RefreshToken({
    this.userId,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [userId, refreshToken];
}
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class SendEmailLoading extends ForgotPasswordState {}

class SendEmailSuccess extends ForgotPasswordState {
  final String email;
  SendEmailSuccess({required this.email});
}

class SendEmailFailure extends ForgotPasswordState {
  final String error;
  SendEmailFailure({required this.error});
}

class VerifyOtpLoading extends ForgotPasswordState {}

class VerifyOtpSuccess extends ForgotPasswordState {
  final String email;
  final String otp;
  VerifyOtpSuccess({required this.email, required this.otp});
}

class VerifyOtpFailure extends ForgotPasswordState {
  final String error;
  VerifyOtpFailure({required this.error});
}

class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {}

class ResetPasswordFailure extends ForgotPasswordState {
  final String error;
  ResetPasswordFailure({required this.error});
}

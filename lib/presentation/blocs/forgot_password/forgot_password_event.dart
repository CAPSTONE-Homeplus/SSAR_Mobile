abstract class ForgotPasswordEvent {}

class SendEmailEvent extends ForgotPasswordEvent {
  final String email;
  SendEmailEvent({required this.email});
}

class VerifyOtpEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  VerifyOtpEvent({required this.email, required this.otp});
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String email;
  final String newPassword;
  ResetPasswordEvent({
    required this.email,
    required this.newPassword
  });
}
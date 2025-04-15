import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../domain/repositories/authentication_repository.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ForgotPasswordInitial()) {
    on<SendEmailEvent>(_onSendEmail);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendEmail(
      SendEmailEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(SendEmailLoading());
    try {
      await _authRepository.sendResetEmail(event.email);
      emit(SendEmailSuccess(email: event.email));
    } on ApiException catch (e) {
      emit(SendEmailFailure(error: e.description ?? 'Lỗi không xác định'));
    } catch (e) {
      emit(SendEmailFailure(error: 'Lỗi không xác định'));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(VerifyOtpLoading());
    try {
      final isValid = await _authRepository.verifyOtp(event.email, event.otp);
      if (isValid) {
        emit(VerifyOtpSuccess(email: event.email, otp: event.otp));
      } else {
        emit(VerifyOtpFailure(error: 'Mã xác nhận không đúng'));
      }
    } on ApiException catch (e) {
      emit(VerifyOtpFailure(error: 'Lỗi xác minh mã OTP'));
    } catch (e) {
      emit(VerifyOtpFailure(error: 'Lỗi không xác định'));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ResetPasswordLoading());
    try {
      await _authRepository.resetPassword(event.email, event.newPassword);
      emit(ResetPasswordSuccess());
    } on ApiException catch (e) {
      emit(ResetPasswordFailure(error: 'Lỗi đặt lại mật khẩu'));
    } catch (e) {
      emit(ResetPasswordFailure(error: 'Lỗi không xác định'));
    }
  }
}

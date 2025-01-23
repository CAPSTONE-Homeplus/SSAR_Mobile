import 'package:home_clean/domain/entities/option.dart';

abstract class OptionState {}

class OptionInitialState extends OptionState {}

class OptionLoadingState extends OptionState {}

class OptionSuccessState extends OptionState {
  final List<Option> options;

  OptionSuccessState({required this.options});
}

class OptionErrorState extends OptionState {
  final String message;

  OptionErrorState({required this.message});
}

part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterEmailVerificationSent extends RegisterState {
  final String email;

  const RegisterEmailVerificationSent({required this.email});

  @override
  List<Object> get props => [email];
}

class RegisterEmailVerificationChecked extends RegisterEvent {
  final AuthUserInfo user;

  const RegisterEmailVerificationChecked({required this.user});

  @override
  List<Object> get props => [user];
}

final class RegisterSuccess extends RegisterState {
  final AuthUserInfo user;
  final String password;

  const RegisterSuccess({required this.user, required this.password});

  @override
  List<Object> get props => [user];
}

final class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure({required this.error});

  @override
  List<Object> get props => [error];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/src/auth/auth.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;
  
  RegisterBloc({required this.registerRepository}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<RegisterEmailVerificationChecked>(_onRegisterEmailVerificationChecked);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final user = await registerRepository.register(event.name, event.email, event.password);
      //TODO BACKEND CALL
      emit(RegisterSuccess(user: user));
    } on AuthException catch (e) {
      final msg = e.message;
      if (msg == 'Email already in use') {
        emit(RegisterFailure(error: 'This email is already registered. Please log in or reset your password.'));
      } else if (msg == 'Invalid email format') {
        emit(RegisterFailure(error: 'The email address is not valid.'));
      } else if (msg == 'Weak password') {
        emit(RegisterFailure(error: 'The password is too weak. Please choose a stronger one.'));
      } else {
        emit(RegisterFailure(error: msg));
      }
    } catch (e) {
      emit(RegisterFailure(error: 'Unexpected error'));
    }
  }

  Future<void> _onRegisterEmailVerificationChecked(
    RegisterEmailVerificationChecked event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterSuccess(user: event.user));
  }
}

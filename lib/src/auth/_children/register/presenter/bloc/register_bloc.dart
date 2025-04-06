import 'package:bloc/bloc.dart';
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
      final user = await registerRepository.register(event.username, event.password);
      emit(RegisterEmailVerificationSent(email: user.email));
    } on AuthException catch (e) {
      emit(RegisterFailure(error: e.message));
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

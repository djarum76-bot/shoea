import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoea/repositories/auth_repository.dart';
import 'package:shoea/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthBloc({required this.authRepository, required this.userRepository}) : super(const AuthState()) {
    on<RegisterRequested>(
      _onRegisterRequested
    );
    on<LoginRequested>(
      _onLoginRequested
    );
    on<LogoutRequested>(
      _onLogoutRequested
    );
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit)async{
    emit(state.copyWith(status: AuthStatus.loading));
    try{
      await authRepository.register(event.email, event.password);
      emit(state.copyWith(
        status: AuthStatus.authenticatedNoData,
      ));
    }catch(e){
      emit(state.copyWith(
        status: AuthStatus.authError,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit)async{
    emit(state.copyWith(status: AuthStatus.loading));
    try{
      await authRepository.login(event.email, event.password);
      final user = await userRepository.getUser();
      if(user.name!.valid == false){
        emit(state.copyWith(
          status: AuthStatus.authenticatedNoData
        ));
      }else if(user.pin!.valid == false){
        emit(state.copyWith(
          status: AuthStatus.authenticatedNoPIN
        ));
      }else{
        emit(state.copyWith(
          status: AuthStatus.authenticated
        ));
      }
    }catch(e){
      emit(state.copyWith(
        status: AuthStatus.authError,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit)async{
    emit(state.copyWith(status: AuthStatus.loading));
    try{
      await authRepository.logout();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated
      ));
    }catch(e){
      emit(state.copyWith(
        status: AuthStatus.authError,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }
}
part of 'auth_bloc.dart';

enum AuthStatus { loading, unauthenticated, authenticated, authenticatedNoData, authenticatedNoPIN, authError }

class AuthState extends Equatable{
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.message
  });

  final AuthStatus status;
  final String? message;

  @override
  List<Object?> get props => [status];

  AuthState copyWith({
    AuthStatus? status,
    String? message
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''AuthState { status : $status }''';
  }
}

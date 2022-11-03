part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({
    this.user,
    this.image,
    this.status = FormzStatus.pure,
    this.message
  });

  final UserModel? user;
  final String? image;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [user, image, status];

  UserState copyWith({
    UserModel? user,
    ValueGetter<String?>? image,
    FormzStatus? status,
    String? message
  }) {
    return UserState(
      user: user ?? this.user,
      image: image != null ? image() : this.image,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''UserState { status : $status }''';
  }
}

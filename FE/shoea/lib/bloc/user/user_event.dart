part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FillUserImage extends UserEvent{}

class FillUserData extends UserEvent{
  final String imagePath;
  final String name;
  final String date;
  final String phone;
  final String gender;

  FillUserData(this.imagePath, this.name, this.date, this.phone, this.gender);
}

class FillUserPin extends UserEvent{
  final String pin;

  FillUserPin(this.pin);
}

class UpdateUserImage extends UserEvent{}

class UpdateUserProfile extends UserEvent{
  final String name;
  final String date;
  final String phone;
  final String gender;

  UpdateUserProfile(this.name, this.date, this.phone, this.gender);
}

class UserFetched extends UserEvent{}
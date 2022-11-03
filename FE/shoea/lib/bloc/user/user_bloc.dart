import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoea/models/user_model.dart';
import 'package:shoea/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserState()) {
    on<FillUserImage>(
      _onFillUserImage
    );
    on<FillUserData>(
      _onFillUserData
    );
    on<FillUserPin>(
      _onFillUserPin
    );
    on<UpdateUserImage>(
      _onUpdateUserImage
    );
    on<UpdateUserProfile>(
      _onUpdateUserProfile
    );
    on<UserFetched>(
      _onFetchUser
    );
  }

  Future<void> _onFillUserImage(FillUserImage event, Emitter<UserState> emit)async{
    try{
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image != null){
        emit(state.copyWith(
          image: () => image.path
        ));
      }
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onFillUserData(FillUserData event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await userRepository.fillUserData(event.imagePath, event.name, event.date, event.phone, event.gender);
      emit(state.copyWith(
        image: () => null,
        status: FormzStatus.submissionSuccess
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onFillUserPin(FillUserPin event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await userRepository.fillUserPin(event.pin);
      final user = await userRepository.getUser();
      emit(state.copyWith(
        user: user,
        status: FormzStatus.submissionSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onUpdateUserImage(UpdateUserImage event, Emitter<UserState> emit)async{
    try{
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image != null){
        await userRepository.updatePhoto(image.path);
      }

      final user = await userRepository.getUser();
      emit(state.copyWith(
        user: user
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onUpdateUserProfile(UpdateUserProfile event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try{
      await userRepository.updateProfile(event.name, event.date, event.phone, event.gender);
      final user = await userRepository.getUser();
      emit(state.copyWith(
        user: user,
        status: FormzStatus.submissionSuccess
      ));
    }catch(e){
      emit(state.copyWith(
          message: e.toString(),
          status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }

  Future<void> _onFetchUser(UserFetched event, Emitter<UserState> emit)async{
    try{
      final user = await userRepository.getUser();
      emit(state.copyWith(
        user: user,
      ));
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        status: FormzStatus.submissionFailure
      ));
      throw Exception(e);
    }
  }
}

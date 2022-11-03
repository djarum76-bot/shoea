import 'package:flutter_bloc/flutter_bloc.dart';

class DateCubit extends Cubit<DateTime>{
  DateCubit(super.initialState);

  void changeDate(DateTime value){
    emit(value);
  }
}
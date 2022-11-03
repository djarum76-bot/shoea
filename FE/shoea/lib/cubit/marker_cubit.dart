import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerCubit extends Cubit<Set<Marker>>{
  MarkerCubit() : super(const <Marker>{});

  void updateMarker(LatLng position){
    emit(<Marker>{});
    emit({
      Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarker
      )
    });
  }
}
part of 'address_bloc.dart';

class AddressEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ProvinceSelected extends AddressEvent{
  final ProvinceModel selectedProvince;

  ProvinceSelected(this.selectedProvince);
}

class CitySelected extends AddressEvent{
  final CityModel selectedCity;

  CitySelected(this.selectedCity);
}

class AddressAdded extends AddressEvent{
  final String provinceID;
  final String cityID;
  final double lat;
  final double lng;
  final String addressName;
  final String addressDetail;

  AddressAdded(this.provinceID, this.cityID, this.lat, this.lng, this.addressName, this.addressDetail);
}

class AddressFetched extends AddressEvent{}

class AddressDefaultChanged extends AddressEvent{
  final int id;

  AddressDefaultChanged(this.id);
}

class AddressUpdated extends AddressEvent{
  final int id;
  final String provinceID;
  final String cityID;
  final String addressName;
  final String addressDetail;

  AddressUpdated(this.id, this.provinceID, this.cityID, this.addressName, this.addressDetail);
}
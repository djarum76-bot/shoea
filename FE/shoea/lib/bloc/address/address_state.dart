part of 'address_bloc.dart';

enum AddressStatus { initial, error, fetchLoading, updateLoading, addLoading, fetchSuccess, addSuccess, updateMapSuccess, updateDefaultSuccess }

class AddressState extends Equatable{
  const AddressState({
    this.addresses = const <AddressModel>[],
    this.address,
    this.selectedProvince,
    this.selectedCity,
    this.status = AddressStatus.initial,
    this.message
  });

  final List<AddressModel> addresses;
  final AddressModel? address;
  final ProvinceModel? selectedProvince;
  final CityModel? selectedCity;
  final AddressStatus status;
  final String? message;

  @override
  List<Object?> get props => [addresses, address, selectedProvince, selectedCity, status];

  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? address,
    ValueGetter<ProvinceModel?>? selectedProvince,
    ValueGetter<CityModel?>? selectedCity,
    AddressStatus? status,
    String? message,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      address: address ?? this.address,
      selectedProvince: selectedProvince != null ? selectedProvince() : this.selectedProvince,
      selectedCity: selectedCity != null ? selectedCity() : this.selectedCity,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''AddressState { status : $status }''';
  }
}
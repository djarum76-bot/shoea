part of 'shoe_bloc.dart';

enum ShoeStatus { initial, loading, loadingOrder, fetchSearchSuccess, fetchHistorySuccess, fetchDetailShoeSuccess, fetchBrandSuccess, fetchAllShoeSuccess, fetchBrandFavoriteSuccess, fetchAllShoeFavoriteSuccess, searchNavigation, addReviewSuccess, error }

class ShoeState extends Equatable{
  const ShoeState({
    this.selectedBrand = const BrandModel(icon: SimpleIcons.adidas, name: "All", id: 0),
    this.shoes = const <ShoeModel>[],
    this.shoe,
    this.status = ShoeStatus.initial,
    this.size,
    this.color,
    this.qty = 1,
    this.search,
    this.histories = const <HistoryModel>[],
    this.favorite,
    this.message
  });

  final BrandModel selectedBrand;
  final List<ShoeModel> shoes;
  final ShoeModel? shoe;
  final ShoeStatus status;
  final Size? size;
  final String? color;
  final int qty;
  final String? search;
  final List<HistoryModel> histories;
  final FavoriteModel? favorite;
  final String? message;

  @override
  List<Object?> get props => [selectedBrand, shoes, shoe, status, size, color, qty, search, histories, favorite];

  ShoeState copyWith({
    BrandModel? selectedBrand,
    List<ShoeModel>? shoes,
    ShoeModel? shoe,
    ShoeStatus? status,
    ValueGetter<Size?>? size,
    ValueGetter<String?>? color,
    int? qty,
    String? search,
    List<HistoryModel>? histories,
    FavoriteModel? favorite,
    String? message,
  }) {
    return ShoeState(
      selectedBrand: selectedBrand ?? this.selectedBrand,
      shoes: shoes ?? this.shoes,
      shoe: shoe ?? this.shoe,
      status: status ?? this.status,
      size: size != null ? size() : this.size,
      color: color != null ? color() : this.color,
      qty: qty ?? this.qty,
      search: search ?? this.search,
      histories: histories ?? this.histories,
      favorite: favorite ?? this.favorite,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''ShoesState { status : $status }''';
  }
}

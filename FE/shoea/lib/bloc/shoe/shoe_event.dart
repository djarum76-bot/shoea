part of 'shoe_bloc.dart';

abstract class ShoeEvent extends Equatable{
  @override
  List<Object> get props => [];
}


class ShoeFetched extends ShoeEvent{
  final BrandModel brand;

  ShoeFetched(this.brand);
}

class ShoeNavigation extends ShoeEvent{
  final BrandModel brand;

  ShoeNavigation(this.brand);
}

class ShoeDetailNavigation extends ShoeEvent{}

class ShoeSearch extends ShoeEvent{
  final String query;

  ShoeSearch(this.query);
}

class ShoeDetailFetched extends ShoeEvent{
  final int id;

  ShoeDetailFetched(this.id);
}

class ShoeSizeChanged extends ShoeEvent{
  final Size size;

  ShoeSizeChanged(this.size);
}

class ShoeColorChanged extends ShoeEvent{
  final String color;

  ShoeColorChanged(this.color);
}

class ShoeQtyIncreased extends ShoeEvent{}

class ShoeQtyDecreased extends ShoeEvent{}

class ShoeReviewAdded extends ShoeEvent{
  final int orderID;
  final int shoeID;
  final double rating;
  final String comment;

  ShoeReviewAdded(this.orderID, this.shoeID, this.rating, this.comment);
}
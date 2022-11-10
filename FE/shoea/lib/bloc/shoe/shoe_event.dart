part of 'shoe_bloc.dart';

abstract class ShoeEvent extends Equatable{
  @override
  List<Object> get props => [];
}


class ShoeFetched extends ShoeEvent{
  final BrandModel brand;
  final bool isFavorite;

  ShoeFetched(this.brand, this.isFavorite);
}

class ShoeNavigation extends ShoeEvent{}

class ShoeSearchNavigation extends ShoeEvent{}

class ShoeHistoryFetched extends ShoeEvent{}

class ShoeHistoryDeleted extends ShoeEvent{
  final String uuid;

  ShoeHistoryDeleted(this.uuid);
}

class ShoeHistoryDeletedAll extends ShoeEvent{}

class ShoeSearchFetched extends ShoeEvent{
  final String query;

  ShoeSearchFetched(this.query);
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

class ShoeFavoriteAdded extends ShoeEvent{
  final HelpModel helper;

  ShoeFavoriteAdded(this.helper);
}

class ShoeFavoriteDeleted extends ShoeEvent{
  final int favoriteID;
  final HelpModel helper;

  ShoeFavoriteDeleted(this.favoriteID, this.helper);
}
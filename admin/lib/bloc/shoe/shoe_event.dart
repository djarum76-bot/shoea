part of 'shoe_bloc.dart';

abstract class ShoeEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ShoeImage extends ShoeEvent{}

class ShoeSizeAdded extends ShoeEvent{
  final List<int> sizes;

  ShoeSizeAdded(this.sizes);
}

class ShoeSizeRemoved extends ShoeEvent{
  final List<int> sizes;

  ShoeSizeRemoved(this.sizes);
}

class ShoeColorAdded extends ShoeEvent{
  final List<int> colors;

  ShoeColorAdded(this.colors);
}

class ShoeColorRemoved extends ShoeEvent{
  final List<int> colors;

  ShoeColorRemoved(this.colors);
}

class ShoeAdded extends ShoeEvent{
  final String brand;
  final String image;
  final String title;
  final String description;
  final int price;
  final List<int> sizes;
  final List<String> colors;

  ShoeAdded(this.brand, this.image, this.title, this.description, this.price, this.sizes, this.colors);
}
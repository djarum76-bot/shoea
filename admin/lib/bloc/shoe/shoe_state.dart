part of 'shoe_bloc.dart';

class ShoeState extends Equatable{
  const ShoeState({
    this.sizes = const <int>[],
    this.colors = const <int>[],
    this.image,
    this.status = FormzStatus.pure,
    this.message
  });

  final List<int> sizes;
  final List<int> colors;
  final String? image;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [sizes, colors, image, status];

  ShoeState copyWith({
    List<int>? sizes,
    List<int>? colors,
    ValueGetter<String?>? image,
    FormzStatus? status,
    String? message
  }) {
    return ShoeState(
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      image: image != null ? image() : this.image,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  String toString(){
    return '''ShoeState { status : $status }''';
  }
}

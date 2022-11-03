import 'package:flutter/material.dart';

class ListViewBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details){
    return child;
  }
}
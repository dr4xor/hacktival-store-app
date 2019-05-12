import 'package:flutter/material.dart';

/// Navigator.of(context).push(FadeRoute(
///   builder: (context) {
///     return NewPage();
///   }
/// ));
class FadeRoute<T> extends PageRoute<T> {

  FadeRoute({@required this.builder});

  final WidgetBuilder builder;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}


String smalifyLink(String url) {
  return "$url=s128";
}
import 'package:flutter/material.dart';

class ViewEvent extends StatefulWidget {
  ViewEvent({this.payLoad, super.key});
  String? payLoad;
  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}

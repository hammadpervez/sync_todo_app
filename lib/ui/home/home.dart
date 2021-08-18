import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/riverpods/pods.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(child: Text("Logged In ")),
        TextButton(
            onPressed: () async {
              await context.read(loginPod).logOut();
              Beamer.of(context).beamToNamed(Routes.main);
            },
            child: Text("Log Out")),
      ],
    )));
  }
}
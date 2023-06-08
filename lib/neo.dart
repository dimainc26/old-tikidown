import 'package:flutter/material.dart';

class Neo extends StatefulWidget {
  const Neo({Key? key}) : super(key: key);

  @override
  State<Neo> createState() => _NeoState();
}

class _NeoState extends State<Neo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            var date = DateTime.now().toString();
            var parse = date.split(" ");
            var dt = parse[0].split("-");

            var tm = parse[1].split(".");
            tm = tm[0].split(":");

            var tms = dt[0] + dt[1] + dt[2] + tm[0] + tm[1] + tm[2];
          },
        ),
      ),
    );
  }
}

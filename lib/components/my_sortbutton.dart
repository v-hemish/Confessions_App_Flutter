import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortOptions extends StatefulWidget {
  final VoidCallback? onLatestPressed;
  final VoidCallback? onTopPressed;

  const SortOptions({Key? key, this.onLatestPressed, this.onTopPressed}) : super(key: key);

  @override
  _SortOptionsState createState() => _SortOptionsState();
}

class _SortOptionsState extends State<SortOptions> {
  bool latestSelected = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              latestSelected = true;
            });
            widget.onLatestPressed?.call();
          },
          icon: Icon(Icons.access_time, color: latestSelected ? Colors.black : Colors.white),
          label: Text('Latest', style: TextStyle(color: latestSelected ? Colors.black : Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: latestSelected ? Colors.white : Colors.black,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              latestSelected = false;
            });
            widget.onTopPressed?.call();
          },
          icon: Icon(Icons.trending_up, color: !latestSelected ? Colors.black : Colors.white),
          label: Text('Top', style: TextStyle(color: !latestSelected ? Colors.black : Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: !latestSelected ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

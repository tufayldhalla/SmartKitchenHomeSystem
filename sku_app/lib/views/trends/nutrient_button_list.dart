import 'package:flutter/material.dart';

class NutrientButtonList extends StatefulWidget {
  final List<String> nutrientList;
      
  NutrientButtonList(this.nutrientList);
  @override
  _NutrientButtonListState createState() => _NutrientButtonListState();
}

class _NutrientButtonListState extends State<NutrientButtonList> {
  int pressedIdx; 

  Widget build(BuildContext context) {
    return Row(
      children: widget.nutrientList.map((item) {
        var index = widget.nutrientList.indexOf(item);
        return Container(
          height: 70,
          child: RaisedButton(
            color: pressedIdx == index ? Theme.of(context).canvasColor : Theme.of(context).cardColor,
            child: new Text(item),
            shape: CircleBorder(),
            onPressed: () {
              if (pressedIdx != index) {
                setState(() {
                  pressedIdx = index;
                });
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
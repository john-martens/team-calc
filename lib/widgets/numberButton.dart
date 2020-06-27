import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final Color fgColor, bgColor;
  final int number;
  final Function updateFn;
  final double size;

  NumberButton(
      {this.size, this.number, this.fgColor, this.bgColor, this.updateFn});

  Color _updateColors() {
    int diff = fgColor.value - bgColor.value;
    return diff < 0 ? fgColor : bgColor;
  }

  void onTap() {
    updateFn(this.number.toString());
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = _updateColors();
    return Container(
      margin: EdgeInsets.symmetric(vertical: size * 0.067, horizontal: 2),
      width: this.size,
      height: this.size * 1.1,
      child: MaterialButton(
        color: this.bgColor,
        textColor: this.fgColor,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
            width: 3.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(size / 2.6),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(width: size * 0.067, color: this.fgColor),
            bottom: BorderSide(width: size * 0.067, color: this.fgColor),
          )),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2, color: this.fgColor),
                bottom: BorderSide(width: 2, color: this.fgColor),
              ),
            ),
            margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
            padding: EdgeInsets.only(top: size * 0.1),
            child: Text(
              "$number",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "OldSportCollege",
                fontSize: this.size * 0.5,
              ),
            ),
          ),
        ),
        padding: EdgeInsets.all(0.095 * size),
        onPressed: onTap,
        minWidth: double.infinity,
        height: this.size * 0.25,
      ),
    );
  }
}

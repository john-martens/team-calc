import 'package:flutter/material.dart';

class ColorTile extends StatelessWidget {
  final Color swatch;
  final Function fn;
  final String colorType;
  final bool isSelected;
  final bool isCustom;

  ColorTile(
      {this.swatch, this.fn, this.colorType, this.isSelected, this.isCustom});

  void _updateColor() {
    if (isCustom) return;
    fn(this.swatch, this.colorType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      margin: EdgeInsets.all(5.0),
      child: MaterialButton(
        color: this.swatch,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              width: isSelected && !isCustom ? 4.0 : 0.0,
              color: swatch == Colors.black ? Colors.white : Colors.black),
        ),
        onPressed: _updateColor,
        child: Text(
          isSelected ? "√" : !isSelected && isCustom ? "?" : "",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: swatch == Colors.black ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

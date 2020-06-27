import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/mathsymbol.dart';

class FunctionButton extends StatelessWidget {
  final double size;
  final Color fgColor, bgColor;
  final String symbol;
  final Function function;

  FunctionButton(
      {this.size, this.symbol, this.fgColor, this.bgColor, this.function});

  void runFunction() {
    switch (symbol) {
      case "+":
        function(MathSymbol.ADD);
        break;
      case "-":
        function(MathSymbol.SUBTRACT);
        break;
      case "x":
        function(MathSymbol.MULTIPLY);
        break;
      case "÷":
        function(MathSymbol.DIVIDE);
        break;
      case "=":
        function(MathSymbol.EQUALS);
        break;
      case "%":
        function(MathSymbol.PERCENT);
        break;
      default:
        function();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size * 0.067, horizontal: 2),
      width: this.symbol == "=" ? size * 2.0 : size,
      height: this.size * 1.1,
      child: MaterialButton(
        color: this.fgColor,
        textColor: this.bgColor,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            color: this.bgColor == Colors.white ? this.fgColor : this.bgColor,
            width: 3.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(size / 2.6),
        ),
        child: Container(
          width: this.symbol == "=" ? this.size * 2.0 : this.size,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 2,
                color: this.bgColor,
              ),
              bottom: BorderSide(
                width: 2,
                color: this.bgColor,
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
            padding: EdgeInsets.all(this.size * 0.067),
            child: Text(
              symbol,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 0.4 * this.size, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        padding: EdgeInsets.all(this.size * 0.09),
        onPressed: runFunction,
        minWidth: double.infinity,
        height: 20 / this.size,
      ),
    );
  }
}

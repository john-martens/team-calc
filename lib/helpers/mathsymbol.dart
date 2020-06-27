enum MathSymbol { none, ADD, SUBTRACT, MULTIPLY, DIVIDE, EQUALS, PERCENT }

extension SymbolExtension on MathSymbol {
  String get symbol {
    switch (this) {
      case MathSymbol.ADD:
        return '+';
      case MathSymbol.SUBTRACT:
        return '-';
      case MathSymbol.MULTIPLY:
        return 'x';
      case MathSymbol.DIVIDE:
        return "÷";
        break;
      case MathSymbol.EQUALS:
        return "=";
        break;
      case MathSymbol.PERCENT:
        return "%";
        break;
      default:
        return " ";
        break;
    }
  }
}

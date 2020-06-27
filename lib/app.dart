import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './color-picker.dart';
import './widgets/numberButton.dart';
import './widgets/functionButton.dart';
import './helpers/mathsymbol.dart';
import 'dart:math';
import './widgets/team-tile.dart';
import './helpers/db-connector.dart';
import './helpers/admob-helper.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color numColor = Colors.yellow[50];
  Color shirtColor = Colors.grey[800];
  Color origNumColor, origShirtColor;
  Color bgColor, fgColor;
  String team = "Team-Calc";
  String val = "0";
  bool hasDecimal = false;
  bool newNum = true;
  double answer = 0;
  MathSymbol prevSymbol = MathSymbol.none;
  bool isSwitched = false;
  List<Map> presets;
  int teamCount;
  double deviceWidth, deviceHeight;
  final amh = AdMobHelper();

  void initState() {
    origNumColor = numColor;
    origShirtColor = shirtColor;
    super.initState();
    Admob.initialize(amh.getAppId());
  }

  Future setDb() async {
    await Provider.of<DBConnector>(context).connect();
  }

  double _roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void upDate(String num) {
    if (val.length >= 12 && !newNum) return;
    setState(() {
      val = val == "0" && !hasDecimal || newNum ? num : val + num;
    });
    if (newNum) newNum = false;
  }

  void plusMinus() {
    if (val == "0" || val == "Error") return;
    double num = double.parse(val) * -1;
    setState(() {
      val = num != num.toInt() ? num.toString() : num.toInt().toString();
    });
  }

  void clearFn() {
    setState(() {
      val = "0";
      answer = 0;
      hasDecimal = false;
      newNum = true;
      prevSymbol = MathSymbol.none;
    });
  }

  void decimal() {
    if (hasDecimal) return;
    setState(() {
      val = newNum ? "0." : val + ".";
      hasDecimal = true;
    });
    if (newNum) {
      newNum = false;
    }
  }

  void updateAnswer(MathSymbol newSymbol) {
    if (val == "Error") return;

    if (answer != 0 && newNum == true) {
      prevSymbol = newSymbol;
      answer = double.parse(val);
      return;
    } else if (answer == 0 && newSymbol == MathSymbol.PERCENT) {
      answer = double.parse(val) / 100;
      hasDecimal = true;
      setState(() {
        val = hasDecimal ? answer.toString() : answer.toInt().toString();
      });
      return;
    }

    switch (prevSymbol) {
      case MathSymbol.ADD:
        answer = newSymbol == MathSymbol.PERCENT
            ? answer + (double.parse(val) / 100 * answer)
            : answer + double.parse(val);
        break;
      case MathSymbol.SUBTRACT:
        answer = newSymbol == MathSymbol.PERCENT
            ? answer - (double.parse(val) / 100 * answer)
            : answer - double.parse(val);
        break;
      case MathSymbol.MULTIPLY:
        answer = newSymbol == MathSymbol.PERCENT
            ? (double.parse(val) / 100 * answer)
            : answer * double.parse(val);
        break;
      case MathSymbol.DIVIDE:
        answer = newSymbol == MathSymbol.PERCENT
            ? (double.parse(val) / 100 * answer)
            : answer / double.parse(val);
        break;
      default:
        answer = double.parse(val);
        break;
    }
    try {
      if (answer != answer.toInt()) hasDecimal = true;
    } catch (e) {
      setState(() {
        val = "Error";
      });
      newNum = true;
      answer = 0;
      prevSymbol = MathSymbol.EQUALS;
      return;
    }

    if (hasDecimal && answer.toString().length > 12) {
      int precision = 11;
      while (true) {
        answer = _roundDouble(answer, precision);
        if (answer.toString().length <= 12) break;
        precision--;
      }
    }

    setState(() {
      val = hasDecimal ? answer.toString() : answer.toInt().toString();
    });

    hasDecimal = false;
    prevSymbol =
        newSymbol == MathSymbol.PERCENT ? MathSymbol.EQUALS : newSymbol;
    newNum = true;
  }

  void _setColors(newValue) {
    Color dark, light;
    int diff = shirtColor.value - numColor.value;

    if (diff < 0) {
      dark = shirtColor;
      light = numColor;
    } else {
      dark = numColor;
      light = shirtColor;
    }
    setState(() {
      bgColor = dark;
      fgColor = light;
      numColor = newValue ? origShirtColor : origNumColor;
      shirtColor = newValue ? origNumColor : origShirtColor;
      isSwitched = newValue;
    });
  }

  void _updateColors(Color newFg, Color newBg, String newTeam) {
    Color dark, light;
    int diff = newBg.value - newFg.value;
    if (diff < 0) {
      dark = newBg;
      light = newFg;
    } else {
      dark = newFg;
      light = newBg;
    }
    setState(() {
      shirtColor = newBg;
      numColor = newFg;
      origShirtColor = newBg;
      origNumColor = newFg;
      bgColor = dark;
      fgColor = light;
      team = newTeam;
      isSwitched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _setColors(isSwitched);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // this will hide Drawer hamburger icon
        actions: <Widget>[Container()],
        backgroundColor: bgColor,
        title: Text(
          "◊   Go  $team   ◊",
          style: TextStyle(
            fontFamily: "OldSportCollege",
            color: fgColor,
            fontSize: team.length < 8 ? 38.0 : 40.0 - team.length * 0.9,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: amh.getBannerId(),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "My Teams",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: "OldSportCollege",
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: setDb(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    presets = Provider.of<DBConnector>(context).teams;

                    return Column(
                      children: <Widget>[
                        Container(
                            color: Colors.black,
                            width: double.infinity,
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Presets: ${presets.length}  |  Still Available: ${10 - presets.length}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        SingleChildScrollView(
                          child: Container(
                            height: .75 * deviceHeight,
                            child: ListView.builder(
                              itemCount: presets.length,
                              itemBuilder: (context, i) => TeamTile(
                                  Color(int.parse(
                                      "0xff" + presets[i]['fgColor'])),
                                  Color(int.parse(
                                      "0xff" + presets[i]['bgColor'])),
                                  presets[i]['name'],
                                  (i + 1),
                                  _updateColors),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 3.0,
                color: bgColor,
              ),
            ),
            width: double.infinity,
            height: 80,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Text(
              "$val",
              textAlign: TextAlign.right,
              style: GoogleFonts.ubuntuMono(fontSize: 0.13 * deviceWidth),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberButton(
                size: .18 * deviceWidth,
                number: 7,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 8,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 9,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: String.fromCharCode(177),
                fgColor: numColor,
                bgColor: shirtColor,
                function: plusMinus,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: MathSymbol.PERCENT.symbol,
                fgColor: numColor,
                bgColor: shirtColor,
                function: updateAnswer,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberButton(
                size: .18 * deviceWidth,
                number: 4,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 5,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 6,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: MathSymbol.MULTIPLY.symbol,
                fgColor: numColor,
                bgColor: shirtColor,
                function: updateAnswer,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: MathSymbol.DIVIDE.symbol,
                fgColor: numColor,
                bgColor: shirtColor,
                function: updateAnswer,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberButton(
                size: .18 * deviceWidth,
                number: 1,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 2,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 3,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: MathSymbol.ADD.symbol,
                fgColor: numColor,
                bgColor: shirtColor,
                function: updateAnswer,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: MathSymbol.SUBTRACT.symbol,
                fgColor: numColor,
                bgColor: shirtColor,
                function: updateAnswer,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: "C",
                fgColor: numColor,
                bgColor: shirtColor,
                function: clearFn,
              ),
              NumberButton(
                size: .18 * deviceWidth,
                number: 0,
                fgColor: numColor,
                bgColor: shirtColor,
                updateFn: upDate,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: ".",
                fgColor: numColor,
                bgColor: shirtColor,
                function: decimal,
              ),
              FunctionButton(
                size: .18 * deviceWidth,
                symbol: MathSymbol.EQUALS.symbol,
                fgColor: numColor,
                bgColor: shirtColor,
                function: updateAnswer,
              ),
            ],
          ),
          Divider(
            color: bgColor,
            thickness: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: bgColor,
                  ),
                ),
                color: Colors.grey[300],
                textColor: Colors.black,
                icon: Icon(Icons.stars),
                label: Text("Presets"),
              ),
              RaisedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ColorPicker(numColor, shirtColor, team)),
                  ).then((value) {
                    if (value == null) return;
                    _updateColors(
                        value["fgcolor"], value["bgcolor"], value["team"]);
                  });
                },
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: bgColor,
                  ),
                ),
                color: Colors.grey[300],
                textColor: Colors.black,
                icon: Icon(Icons.add_to_home_screen),
                label: Text("Custom"),
              ),
              Row(
                children: <Widget>[
                  Switch(
                      activeColor: bgColor,
                      inactiveThumbColor: bgColor.withOpacity(.5),
                      value: isSwitched,
                      onChanged: (value) {
                        _setColors(value);
                      }),
                  Text(
                    "Reverse",
                    style: TextStyle(
                        color: bgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

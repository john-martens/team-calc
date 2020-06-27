import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'widgets/functionButton.dart';
import 'widgets/color-tile.dart';
import 'widgets/numberButton.dart';
import 'helpers/color-list.dart';
import 'helpers/db-connector.dart';
import 'helpers/admob-helper.dart';

import 'dart:math';

class ColorPicker extends StatefulWidget {
  final Color bg, fg;
  final String team;

  ColorPicker(this.fg, this.bg, this.team);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color newBg, newFg;
  String newTeam;
  String id;
  TextEditingController _controller;
  List<Color> clist;
  double deviceWidth, deviceHeight;
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final amh = AdMobHelper();
  InterstitialAd myInterstitial;

  @override
  void initState() {
    newBg = widget.bg;
    newFg = widget.fg;
    newTeam = widget.team;
    id = widget.team.toLowerCase().substring(0, 4) +
        widget.fg.toString().substring(10, 16) +
        widget.bg.toString().substring(10, 16);
    _controller = TextEditingController(text: newTeam);

    myInterstitial = InterstitialAd(
      adUnitId: amh.getFullPageId(),
      listener: (MobileAdEvent event) {
        //print("InterstitialAd event is $event");
      },
    );
    super.initState();
  }

  void _setColor(Color newColor, String which) {
    setState(() {
      newFg = which == "fg" ? newColor : newFg;
      newBg = which == "bg" ? newColor : newBg;
    });
  }

  Widget showSnackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );
  }

  void showAd() {
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    clist = ColorList().getColors();

    if (deviceWidth < 390) {
      clist.removeLast();
    }
    if (deviceWidth < 350) {
      clist.removeLast();
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.grey[800],
          //widget.bg.value - widget.fg.value < 0 ? widget.bg : widget.fg,
          title: Text("Customize"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.cancel,
                size: 18.0,
              ),
              label: Text(
                "Cancel",
                style: TextStyle(fontSize: 12.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.grey[100],
                margin: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Shirt Color",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: clist
                          .map((item) => new ColorTile(
                                swatch: item,
                                fn: _setColor,
                                colorType: "bg",
                                isSelected: newBg == item,
                                isCustom: false,
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton.icon(
                          onPressed: () {
                            _openDialog("Shirt");
                          },
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black54,
                            ),
                          ),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                          icon: Icon(Icons.color_lens),
                          label: Text("Custom"),
                        ),
                        ColorTile(
                          swatch: ColorList().isPreset(newBg)
                              ? Colors.grey[200]
                              : newBg,
                          fn: _setColor,
                          colorType: "bg",
                          isSelected: !ColorList().isPreset(newBg),
                          isCustom: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    )
                  ],
                ),
              ),
              Card(
                color: Colors.grey[100],
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Number Color",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: clist
                          .map((item) => new ColorTile(
                                swatch: item,
                                fn: _setColor,
                                colorType: "fg",
                                isSelected: newFg == item,
                                isCustom: false,
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton.icon(
                          onPressed: () {
                            _openDialog("Number");
                          },
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black54,
                            ),
                          ),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                          icon: Icon(Icons.color_lens),
                          label: Text("Custom"),
                        ),
                        ColorTile(
                          swatch: ColorList().isPreset(newFg)
                              ? Colors.grey[200]
                              : newFg,
                          fn: _setColor,
                          colorType: "fg",
                          isSelected: !ColorList().isPreset(newFg),
                          isCustom: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Preview",
                  style: GoogleFonts.montserrat(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NumberButton(
                    size: deviceHeight > 600 ? 60 : 40,
                    number: 3,
                    fgColor: newFg,
                    bgColor: newBg,
                    updateFn: null,
                  ),
                  FunctionButton(
                    size: deviceHeight > 600 ? 60 : 40,
                    symbol: "C",
                    fgColor: newFg,
                    bgColor: newBg,
                    function: null,
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Enter Team Name",
                  style: GoogleFonts.montserrat(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                width: 300.0,
                margin: EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '4 to 25 characters'),
                  onChanged: (text) {
                    newTeam = text;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    onPressed: () {
                      if (newFg == newBg) {
                        final snackBar =
                            showSnackBar("Colors must be different");
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      newTeam = newTeam.length >= 4 && newTeam.length <= 25
                          ? newTeam
                          : widget.team;
                      var rng = new Random();
                      //show ad 50% of time in simple apply
                      if (rng.nextInt(10) + 1 <= 5) showAd();
                      Navigator.pop(context, {
                        "fgcolor": newFg,
                        "bgcolor": newBg,
                        "team": newTeam
                      });
                    },
                    color: Colors.grey[300],
                    textColor: Colors.black,
                    icon: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                    label: Text("Apply"),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton.icon(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    onPressed: () {
                      if (newFg == newBg) {
                        final snackBar =
                            showSnackBar("Colors must be different");
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      newTeam = newTeam.length >= 4 && newTeam.length <= 25
                          ? newTeam
                          : widget.team;
                      String newid = id.substring(0, 4) +
                          newFg.toString().substring(10, 16) +
                          newBg.toString().substring(10, 16);
                      bool hasTeam =
                          Provider.of<DBConnector>(context, listen: false)
                              .hasTeam(newTeam);
                      bool hasPreset =
                          Provider.of<DBConnector>(context, listen: false)
                              .hasPreset(newid);
                      bool isFull =
                          Provider.of<DBConnector>(context, listen: false)
                                  .teamCount ==
                              10;
                      if (isFull && !hasTeam) {
                        final snackBar = showSnackBar(
                            'You have reached the maximum of 10 presets');
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else if (!hasTeam) {
                        int fgcloc = newFg.toString().indexOf("0xff") + 4;
                        int bgcloc = newBg.toString().indexOf("0xff") + 4;
                        Provider.of<DBConnector>(context, listen: false)
                            .addPreset(
                                newTeam,
                                newFg.toString().substring(fgcloc, fgcloc + 6),
                                newBg.toString().substring(bgcloc, bgcloc + 6));
                        showAd();
                        Navigator.pop(context, {
                          "fgcolor": newFg,
                          "bgcolor": newBg,
                          "team": newTeam
                        });
                      } else if (hasPreset) {
                        final snackBar = showSnackBar(
                            'You already have this preset for ${widget.team}');
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else {
                        showPopUp();
                      }
                    },
                    color: Colors.grey[300],
                    textColor: Colors.black,
                    icon: Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                    label: Text("Apply and Save"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void _openDialog(String which) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Choose $which Color"),
          content: MaterialColorPicker(
              colors: fullMaterialColors,
              selectedColor: which == "Shirt" ? newBg : newFg,
              onColorChange: (color) {
                setState(() {
                  newFg = which == "Shirt" ? newFg : color;
                  newBg = which == "Shirt" ? color : newBg;
                });
              }),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showPopUp() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      title: 'Preset Already Exists for ${widget.team}',
      desc: 'Create New Preset or Update Existing Preset?',
      btnCancelOnPress: () {
        int fgcloc = newFg.toString().indexOf("0xff") + 4;
        int bgcloc = newBg.toString().indexOf("0xff") + 4;
        if (Provider.of<DBConnector>(context, listen: false).teamCount == 10) {
          final snackBar =
              showSnackBar('You have reached the maximum of 10 presets');
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          Provider.of<DBConnector>(context, listen: false).addPreset(
              newTeam,
              newFg.toString().substring(fgcloc, fgcloc + 6),
              newBg.toString().substring(bgcloc, bgcloc + 6));
          showAd();
          Navigator.pop(
              context, {"fgcolor": newFg, "bgcolor": newBg, "team": newTeam});
        }
      },
      btnCancelText: "Create New",
      btnCancelIcon: Icons.add,
      btnCancelColor: Colors.green,
      btnOkOnPress: () {
        Provider.of<DBConnector>(context, listen: false).updatePreset(
            id,
            newFg.toString().substring(10, 16),
            newBg.toString().substring(10, 16));
        showAd();
        Navigator.pop(
            context, {"fgcolor": newFg, "bgcolor": newBg, "team": newTeam});
      },
      btnOkText: "Update",
      btnOkIcon: Icons.edit,
      btnOkColor: Colors.blue,
    )..show();
  }
}

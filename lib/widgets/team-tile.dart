import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/db-connector.dart';
import '../widgets/numberButton.dart';

class TeamTile extends StatelessWidget {
  final Color fgColor, bgColor;
  final String team;
  final int number;
  final Function updateColors;

  TeamTile(
      this.fgColor, this.bgColor, this.team, this.number, this.updateColors);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                height: 60,
                child: NumberButton(
                  size: 50,
                  updateFn: (String val) {
                    updateColors(this.fgColor, this.bgColor, this.team);
                    Navigator.pop(context);
                  },
                  number: this.number,
                  fgColor: this.fgColor,
                  bgColor: this.bgColor,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                height: 60.0,
                child: Center(
                  child: Container(
                    width: 150,
                    child: Text(
                      team,
                      style: TextStyle(
                          fontFamily: "OldSportCollege", fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 30.0,
            child: IconButton(
              iconSize: 25,
              icon: Icon(Icons.delete),
              onPressed: () {
                String newid = team.toLowerCase().substring(0, 4) +
                    fgColor.toString().substring(10, 16) +
                    bgColor.toString().substring(10, 16);
                Provider.of<DBConnector>(context, listen: false)
                    .removePreset(newid);
              },
            ),
          ),
          onTap: () {
            updateColors(this.fgColor, this.bgColor, this.team);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

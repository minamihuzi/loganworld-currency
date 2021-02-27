import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phothpraph/Components/validations.dart';
import 'package:phothpraph/data/datamodel/datatypes.dart';
import 'package:phothpraph/theme/style.dart';
import 'package:phothpraph/data/database/userinfo.dart';
import 'package:phothpraph/router.dart';
import 'dart:io';
import 'package:phothpraph/screens/bottom_bar/bottom_bar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';

class StatisticScreen extends StatefulWidget {
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  List<charts.Series> seriesList;
  bool animate;
  int cindex = -1;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final globalSalesData = [
      new OrdinalSales('Usd ', 50),
      new OrdinalSales('Try ', 25),
      new OrdinalSales('Euro ', 30),
      new OrdinalSales('Photos ', 75),
      new OrdinalSales('Clients ', 60),
    ];

    final losAngelesSalesData = [
      new OrdinalSales('Usd ', 60),
      new OrdinalSales('Try ', 40),
      new OrdinalSales('Euro ', 10),
      new OrdinalSales('Photos ', 20),
      new OrdinalSales('Clients ', 30),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Last Month',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: globalSalesData,
        fillColorFn: (OrdinalSales sales, _) =>
            charts.ColorUtil.fromDartColor(Colors.transparent),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'This Month',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: losAngelesSalesData,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      new charts.Series<OrdinalSales, String>(
        id: 'Last Month',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: globalSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Last Month',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: globalSalesData,
        fillColorFn: (OrdinalSales sales, _) =>
            charts.ColorUtil.fromDartColor(Colors.transparent),
      ),
      // Set the 'Los Angeles Revenue' series to use the secondary measure axis.
      // All series that have this set will use the secondary measure axis.
      // All other series will use the primary measure axis.
    ];
  }

  var hunit;
  var wunit;

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    cindex = -1;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    hunit = size.height / 900;
    wunit = size.width / 390;
    return Scaffold(
        bottomNavigationBar: Nav_bar(),
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0da6ea), Color(0xff81cff5)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              //header
              Container(
                  margin: EdgeInsets.only(top: 70 * hunit),
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("STATISTICS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27 * unit,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        "How effective your job is in comparision\nwith the previous month",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14 * unit,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
              //ntro
              Positioned(
                bottom: 0,
                child: Container(
                    padding: EdgeInsets.only(
                        top: 30 * hunit, left: 30 * hunit, right: 20 * hunit),
                    width: size.width,
                    height: 620 * hunit,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Stack(
                      children: [
                        Container(
                            height: 600 * hunit,
                            width: size.width,
                            child: charts.BarChart(
                              seriesList,
                              animate: animate,
                              barGroupingType: charts.BarGroupingType.grouped,
                              vertical: false,
                              selectionModels: [
                                new charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener: (model) {
                                    print(
                                        'Change in ${model.selectedDatum.first.index}');
                                    setState(() {
                                      cindex = model.selectedDatum.first.index;
                                    });
                                  },
                                  updatedListener: (model) {},
                                ),
                              ],
                              defaultRenderer: new charts.BarRendererConfig(
                                  cornerStrategy: charts.ConstCornerStrategy(
                                      2 * unit.round())),
                              domainAxis: new charts.OrdinalAxisSpec(
                                  showAxisLine: false,
                                  renderSpec: new charts.SmallTickRendererSpec(
                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize:
                                            14 * unit.round(), // size in Pts.
                                        color: charts.Color.fromHex(
                                            code: '#999999')),
                                  )),
                              primaryMeasureAxis: new charts.NumericAxisSpec(
                                  renderSpec: new charts.GridlineRendererSpec(
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.transparent),
                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 0 * unit.round(), // size in Pts.
                                    color: charts.MaterialPalette.black),
                              )),
                              secondaryMeasureAxis: new charts.NumericAxisSpec(
                                  renderSpec: new charts.GridlineRendererSpec(
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.transparent),
                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 0 * unit.round(), // size in Pts.
                                    color: charts.MaterialPalette.black),
                              )),
                            )),
                        if (cindex != -1)
                          Positioned(
                            top: (85.0 * cindex + 20) * unit,
                            right: 40 * unit,
                            child: Container(
                              padding: EdgeInsets.all(10 * unit),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey[300], width: 2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("  Photos", style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14 * unit,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 2 * unit),
                                  Text("This Month",
                                      style: TextStyle(
                                          color: Colors.blue[400],
                                          fontSize: 12 * unit,
                                          fontWeight: FontWeight.bold)),
                                  Text("3908",
                                      style: TextStyle(
                                          color: Colors.blue[400],
                                          fontSize: 12 * unit,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5 * unit),
                                  Text("Last Month",
                                      style: TextStyle(
                                          color: Colors.blue[300],
                                          fontSize: 12 * unit,
                                          fontWeight: FontWeight.bold)),
                                  Text("2750",
                                      style: TextStyle(
                                          color: Colors.blue[300],
                                          fontSize: 12 * unit,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          )
                      ],
                    )),
              ),
              //container
            ],
          ),
        ));
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

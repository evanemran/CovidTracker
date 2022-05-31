import 'package:covid_tracker/Models/GlobalData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'Manager/api_client.dart';

void main() {
  runApp(const MyApp());
}

FutureBuilder<GlobalData> _buildGlobalData(BuildContext context) {

  final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
  return FutureBuilder<GlobalData>(

    future: client.getGlobalData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        final GlobalData? gData = snapshot.data;
        Map<String, double> dataMap = {
          "Total Cases ": gData!.cases!.toDouble(),
          "Recovered": gData.recovered!.toDouble(),
          "Death": gData.deaths!.toDouble(),
          "Active": gData.active!.toDouble(),
        };
        return buildGlobalData(context, dataMap);
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.red,
            // backgroundColor: Colors.white,
          ),
        );
      }
    },
  );
}

PieChart buildGlobalData(BuildContext context, Map<String, double> dataMap) {
  final colorList = <Color>[
    const Color(0xF41D80FA),
    const Color(0xfff5db18),
    const Color(0xF4FF0707),
    const Color(0xffe17055),
  ];
  return PieChart(
    dataMap: dataMap,
    animationDuration: Duration(milliseconds: 800),
    chartLegendSpacing: 32,
    chartRadius: MediaQuery.of(context).size.width / 3.2,
    colorList: colorList,
    initialAngleInDegree: 0,
    chartType: ChartType.ring,
    ringStrokeWidth: 32,
    centerText: "",
    legendOptions: LegendOptions(
      showLegendsInRow: false,
      legendPosition: LegendPosition.right,
      showLegends: true,
      legendShape: BoxShape.rectangle,
      legendTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    chartValuesOptions: ChartValuesOptions(
      showChartValueBackground: true,
      showChartValues: true,
      showChartValuesInPercentage: true,
      showChartValuesOutside: false,
      decimalPlaces: 1,
    ),
    // gradientList: ---To add gradient colors---
    // emptyColorGradient: ---Empty Color gradient---
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Covid Data'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           _buildGlobalData,
      //         ],
      //       )
      //     ],
      //   ),
      // ),
      body: _buildGlobalData(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:covid_tracker/Models/GlobalData.dart';
import 'package:covid_tracker/Models/HistorycalData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'Manager/api_client.dart';
import 'Styles/TextStyles.dart';

GlobalData globalData = new GlobalData();

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
        globalData = snapshot.data!;
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

Widget buildGlobalStats(){
  return Row(
    children: [
      Text("Cases ",
        style: homeMenuTextStyle(),
      textAlign: TextAlign.left,),
      Text(globalData.cases.toString(),
        style: homeMenuTextStyle(),
      textAlign: TextAlign.right,)
    ],
  );
}

Widget buildGlobalHistory(){
  List<HistorycalData> data = [
    HistorycalData('May 25', 527354471),
    HistorycalData('May 26', 527867629),
    HistorycalData('May 27', 528432811),
    HistorycalData('May 28', 528722090),
    HistorycalData('May 29', 528997416),
    HistorycalData('May 30', 529371340),
    HistorycalData('May 31', 530026542)
  ];
  return Column(
    children: [
      SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          // Chart title
          title: ChartTitle(text: 'Last 1 week case analysis',
          textStyle: TextStyle(
            color: Colors.black
          )),
          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<HistorycalData, String>>[
            LineSeries<HistorycalData, String>(
                dataSource: data,
                xValueMapper: (HistorycalData sales, _) => sales.time,
                yValueMapper: (HistorycalData sales, _) => sales.data,
                name: 'Cases',
                color: Colors.red,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]),
      // Expanded(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     //Initialize the spark charts widget
      //     child: SfSparkLineChart.custom(
      //       //Enable the trackball
      //       trackball: SparkChartTrackball(
      //           activationMode: SparkChartActivationMode.tap),
      //       //Enable marker
      //       marker: SparkChartMarker(
      //           displayMode: SparkChartMarkerDisplayMode.all),
      //       //Enable data label
      //       labelDisplayMode: SparkChartLabelDisplayMode.all,
      //       xValueMapper: (int index) => data[index].time,
      //       yValueMapper: (int index) => data[index].data,
      //       dataCount: 5,
      //     ),
      //   ),
      // )
    ],
  );
}

Widget buildGlobalData(BuildContext context, Map<String, double> dataMap) {
  final colorList = <Color>[
    const Color(0xF41D80FA),
    const Color(0xfff5db18),
    const Color(0xF4FF0707),
    const Color(0xffe17055),
  ];

  return SingleChildScrollView(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Card(
          elevation: 10,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: PieChart(
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
              // legendPosition: LegendPosition.right,
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
          ),
          ),
        ),
        // Card(
        //   elevation: 10,
        //   color: Colors.white,
        //   child: Padding(
        //     padding: EdgeInsets.all(20),
        //     child: buildGlobalStats(),
        //   ),
        // ),
        Card(
          elevation: 10,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: buildGlobalHistory(),
          ),
        ),
      ],
    ),
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
      body: _buildGlobalData(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

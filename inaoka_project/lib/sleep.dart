import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inaoka_project/addsleep.dart';

class Sleep extends StatefulWidget {
  const Sleep({super.key});

  //get aveSleep => null;
  double getavesleep() {
    if (_SleepState().aveSleep != null)
    {
      return _SleepState().aveSleep;
    }
    else
    {
      return 8.0;
    }
  }

  @override
  State<Sleep> createState() => _SleepState();
}

class _SleepState extends State<Sleep> {

  //睡眠時間の記録（要素数：７）
  late List<double> sleepTime = <double>[0,0,0,0,0,0,0];

  //平均睡眠時間
  late double aveSleep = double.parse(
      ((sleepTime.reduce((a,b)=>a + b)) / sleepTime.length).
      toStringAsFixed(2));

  @override
  void initState(){
    super.initState();
    // sleepTime = [
    //   0,
    //   0,
    //   0,
    //   0,
    //   0,
    //   0,
    //   0
    // ];
    // aveSleep = double.parse(
    //   ((sleepTime.reduce((a,b)=>a + b)) / sleepTime.length).
    //   toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    //変数管理
  //スクリーンサイズ
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //棒グラフ
            SizedBox(
              width: screenWidth * 0.95,
              height: screenHeight * 0.75 * 0.55,

              child: BarChart(
                BarChartData(

                  //枠線の表示
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),

                  //グラフのタイトル表示
                  titlesData:  const FlTitlesData(
                    topTitles: AxisTitles(
                      axisNameWidget: Text(
                        "睡眠時間",
                      ),
                      axisNameSize: 35.0,
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),

                  //棒グラフのデータを表示
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: sleepTime[0], width: 15, color: Colors.green[300]),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: sleepTime[1], width: 15, color: Colors.green[300]),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: sleepTime[2], width: 15, color: Colors.green[300]),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(toY: sleepTime[3], width: 15, color: Colors.green[300]),
                    ]),
                    BarChartGroupData(x: 5, barRods: [
                      BarChartRodData(toY: sleepTime[4], width: 15, color: Colors.green[300]),
                    ]),
                    BarChartGroupData(x: 6, barRods: [
                      BarChartRodData(toY: sleepTime[5], width: 15, color: Colors.green[300]),
                    ]),
                    BarChartGroupData(x: 7, barRods: [
                      BarChartRodData(toY: sleepTime[6], width: 15, color: Colors.green[300]),
                    ]),
                  ],
                ),
              ),
            ),
            //空白
            SizedBox(
              width: screenWidth * 0.95,
              height: screenHeight * 0.07,
            ),
            //平均睡眠時間の表示
            Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.10,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.orange[200],
              ),
              child: Center(
                child: Text(
                  '平均で''$aveSleep''時間寝ています',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
              )
            ),
            //空白
            SizedBox(
              width: screenWidth * 0.95,
              height: screenHeight * 0.03,
            ),
            //睡眠時間入力画面への移動
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>const Addsleep())
                );

                if(result != null)
                {
                  setState(() {
                    sleepTime.add(double.parse(result));
                    if(sleepTime.length > 7)
                    {
                      sleepTime.removeAt(0);
                    }
                    aveSleep = double.parse(
                      ((sleepTime.reduce((a,b)=>a + b)) / sleepTime.length).
                      toStringAsFixed(2));
                  });
                }
              }, 
              child: const Text('睡眠時間入力'),
            ),
          ],
        ),
      ),
    );
  }
}
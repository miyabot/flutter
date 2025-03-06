import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inaoka_project/addweight.dart';

class Weight extends StatefulWidget {
  final Function(double) onWeightUpdated;  // コールバック関数

  const Weight({super.key, required this.onWeightUpdated});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  // 体重の記録（要素数：最大7）
  late List<double> weightList;

  // 現在の身長
  late double nowHeight;

  // 体重の変化量
  late double difWeight;
  
  // BMI値
  late double bmi;

  @override
  void initState() {
    super.initState();
    // 初期データ設定
    weightList = [0,0,0,0,0,0,0];
    nowHeight = 1.65;
    _updateStats();
  }

  // 体重データの変化量とBMIを更新
  void _updateStats() {
    setState(() {
      difWeight = double.parse((weightList.last - weightList[weightList.length - 2]).toStringAsFixed(1));
      bmi = double.parse((weightList.last / (nowHeight * nowHeight)).toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズ取得
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // 体重グラフ
            SizedBox(
              width: screenWidth * 0.95,
              height: screenHeight * 0.75 * 0.55,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(weightList.length, (index) => FlSpot(index.toDouble() + 1, weightList[index])),
                      isCurved: false,
                      color: Colors.blue,
                    ),
                  ],
                  lineTouchData: const LineTouchData(enabled: true),
                  titlesData: const FlTitlesData(
                    topTitles: AxisTitles(
                      axisNameWidget: Text("体重（kg）"),
                      axisNameSize: 35.0,
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  maxY: 80.0,
                  minY: 0.0,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.07),

            // 体重変化表示
            _infoBox('昨日から $difWeight kg 変化しました', screenWidth, screenHeight),

            SizedBox(height: screenHeight * 0.03),

            // BMI表示
            _infoBox('現在のBMI値は $bmi です', screenWidth, screenHeight),

            SizedBox(height: screenHeight * 0.03),

            // 体重追加ページへの移動ボタン
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Addweight()),
                );

                if (result != null) {
                  double keyW = double.parse(result['wkey']);
                  double keyH = double.parse(result['hkey']);

                  setState(() {
                    weightList.add(keyW);
                    if (weightList.length > 7) {
                      weightList.removeAt(0);
                    }
                    nowHeight = keyH / 100;
                    _updateStats();
                  });

                  // 親ウィジェットに最新体重を渡す
                  widget.onWeightUpdated(weightList.last);
                }
              }, 
              child: const Text('体重入力'),
            )
          ],
        ),
      ),
    );
  }

  // 体重/BMI情報の表示ボックスウィジェット
  Widget _infoBox(String text, double width, double height) {
    return Container(
      width: width * 0.85,
      height: height * 0.10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.amber[200],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

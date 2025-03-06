import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:WeatherInfo()
    );
  }
}

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({super.key});

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  TextEditingController _controller = TextEditingController();
  String areaName = '';
  String weather = '';
  double temperature = 0;
  int humidity = 0;
  double temperatureMax = 0;
  double temperatureMin = 0;

  Future<void> loadWeather(String query) async{
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?appid=8701235f083afe1cd2a2802d8197fcc4&lang=ja&units=metric&q=$query'
    ));
    if(response.statusCode != 200){
      print(response.statusCode);
      return;
    }

    print(response.body);
    //デコードしたデータをMap<String,dynamic>に変換
    final body = json.decode(response.body) as Map<String,dynamic>;
    final main = (body['main' ?? {}]) as Map<String,dynamic>;
    setState(() {
      areaName = body['name'];
      weather = (body['weather']?[0]?['description'] ?? '') as String;
      humidity = (main['humdity'] ?? 0)as int;
      temperature = (main['temp'] ?? 0) as double;
      temperatureMax = (main['temp_max'] ?? 0) as double;
      temperatureMin = (main['temp_min'] ?? 0) as double;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value){
            if(value.isNotEmpty){
              loadWeather(value);
            }
          },
        )
      ),
      body:ListView(
        children: [
          ListTile(title: const Text('地域'),subtitle: Text(areaName),),
          ListTile(title: const Text('天気'),subtitle: Text(weather),),
          ListTile(title: const Text('温度'),subtitle: Text(temperature.toString()),),
          ListTile(title: const Text('最高温度'),subtitle: Text(temperatureMax.toString()),),
          ListTile(title: const Text('最低温度'),subtitle: Text(temperatureMin.toString()),),
          ListTile(title: const Text('湿度'),subtitle: Text(humidity.toString()),),
        ],
      )
    );
  }
}
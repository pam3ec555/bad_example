import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(BadStatefulApp("Some title"));
}

class BadStatefulApp extends StatelessWidget {
  final String title;

  BadStatefulApp(this.title);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BadStatefulScreen(),
    );
  }
}

class BadStatefulScreen extends StatefulWidget {
  @override
  _BadStatefulScreenState createState() => _BadStatefulScreenState();
}

class _BadStatefulScreenState extends State<BadStatefulScreen> {
  final List<dynamic> data = [];
  const apiUrl = 'https://api.example.com/data';

  @override
  void initState() {
    super.initState();
    fetchData(); // Начинаем загрузку данных сразу после инициализации состояния
  }

  fetchData() async {
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Ошибка при получении данных: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text(
            'Данные с бэкенда:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['name']),
                  subtitle: Text(data[index]['description']),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchData(); // Запрашиваем данные снова по нажатию кнопки
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

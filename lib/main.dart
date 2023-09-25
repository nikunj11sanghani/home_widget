import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'api_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ApiResponse> futureAlbum;
  String news = "";

  Future<ApiResponse> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=apple&from=2023-09-20&to=2023-09-20&sortBy=popularity&apiKey=b103d75dfead46c9a180d6bb93390982"));
    if (response.statusCode == 200) {
      ApiResponse apiResponse =
          ApiResponse.fromJson(json.decode(response.body));
      List<String> titles = apiResponse.articles.map((e) => e.title).toList();
      List<String> image = apiResponse.articles.map((e) => e.urlToImage).toList();
      updateAppWidget(titles,image);
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    futureAlbum = fetchAlbum();
    HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    await HomeWidget.getWidgetData<String>('news', defaultValue: "News App")
        .then((value) {
      news = value!;
    });
    setState(() {});
  }

  Future<void> updateAppWidget(List<String> title,List<String> image) async {
    await HomeWidget.saveWidgetData<String>('news', json.encode(title[1]));
    await HomeWidget.saveWidgetData<String>('image_url', json.encode(image[1]));
    await HomeWidget.updateWidget(
        name: 'HomeScreenWidgetProvider', iOSName: 'HomeScreenWidgetProvider');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: futureAlbum,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.articles[index].title),
                      subtitle: Text(
                          "Author :${snapshot.data!.articles[index].author}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 20,
                      thickness: 2,
                      endIndent: 10,
                      indent: 10,
                    );
                  },
                  itemCount: snapshot.data.articles.length);
            }
            if (snapshot.hasError) {
              return Text("Error ${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

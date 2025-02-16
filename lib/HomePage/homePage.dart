import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/apilinks/allapi.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> trendinglisthome() async {
    var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
    if (trendingweekresponse.statusCode == 200) {
      var tempdata = jsonDecode(trendingweekresponse.body);
      var trendingweekjson = tempdata['results'];
      trendinglist = List<Map<String, dynamic>>.from(trendingweekjson.map((item) => {
        'id': item['id'],
        'poster_path': item['poster_path'],
        'vote_average': item['vote_average'],
        'media_type': item['media_type'],
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendinglisthome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        height: MediaQuery.of(context).size.height,
                      ),
                      items: trendinglist.map((item) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('https://image.tmdb.org/t/p/w500${item['poster_path']}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load data'));
                  } else {
                    return Center(child: CircularProgressIndicator(color: Colors.amber));
                  }
                },
              ),
            ),
            title: Text('Trending', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Center(child: Text('Sample Text')),
            ]),
          ),
        ],
      ),
    );
  }
}
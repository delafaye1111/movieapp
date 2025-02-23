import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/apikey/apikey.dart';
import 'package:movieapp/repeatedfunction/slider.dart';


class TvSeries extends StatefulWidget {
  const TvSeries({super.key});

  @override
  State<TvSeries> createState() => _TvSeriesState();
}

class _TvSeriesState extends State<TvSeries> {
  List<Map<String, dynamic>> populartvseries = [];
  List<Map<String, dynamic>> topratedtvseries = [];
  List<Map<String, dynamic>> onairtvseries = [];

  String populartvseriesurl =
      'https://api.themoviedb.org/3/tv/popular?api_key=$apikey';
  String topratedtvseriesurl =
      'https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey';
  String onairtvseriesurl =
      'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey';

  Future<void> tvseriesfunction() async {
    var populartvresponse = await http.get(Uri.parse(populartvseriesurl));
    if (populartvresponse.statusCode == 200) {
      var tempdata = jsonDecode(populartvresponse.body);
      var populartvjson = tempdata['results'];
      for (var i = 0; i < populartvjson.length; i++) {
        populartvseries.add({
          'name': populartvjson[i]['name'],
          'poster_path': populartvjson[i]['poster_path'],
          'vote_average': populartvjson[i]['vote_average'],
          'Date': populartvjson[i]['first_air_date'],
          'id': populartvjson[i]['id'],
        });
      }
    } else {
      print(populartvresponse.statusCode);
    }
    var topratedtvresponse = await http.get(Uri.parse(topratedtvseriesurl));
    if (topratedtvresponse.statusCode == 200) {
      var tempdata = jsonDecode(topratedtvresponse.body);
      var topratedtvjson = tempdata['results'];
      for (var i = 0; i < topratedtvjson.length; i++) {
        topratedtvseries.add({
          'name': topratedtvjson[i]['name'],
          'poster_path': topratedtvjson[i]['poster_path'],
          'vote_average': topratedtvjson[i]['vote_average'],
          'Date': topratedtvjson[i]['first_air_date'],
          'id': topratedtvjson[i]['id'],
        });
      }
    } else {
      print(populartvresponse.statusCode);
    }
    var onairtvresponse = await http.get(Uri.parse(onairtvseriesurl));
    if (onairtvresponse.statusCode == 200) {
      var tempdata = jsonDecode(onairtvresponse.body);
      var onairtvjson = tempdata['results'];
      for (var i = 0; i < onairtvjson.length; i++) {
        onairtvseries.add({
          'name': onairtvjson[i]['name'],
          'poster_path': onairtvjson[i]['poster_path'],
          'vote_average': onairtvjson[i]['vote_average'],
          'Date': onairtvjson[i]['first_air_date'],
          'id': onairtvjson[i]['id'],
        });
      }
    } else {
      print(populartvresponse.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tvseriesfunction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
                child: CircularProgressIndicator(color: Colors.amber.shade400));
          else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sliderlist(populartvseries, 'Popular Tv Series', 'tv', 20),
                sliderlist(topratedtvseries, 'Top rated Series', 'tv', 20),
                sliderlist(onairtvseries, 'On the air', 'tv', 20),

              ],
            );
          }
        });
  }
}

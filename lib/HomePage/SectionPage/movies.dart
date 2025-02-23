import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/apikey/apikey.dart';
import 'package:movieapp/repeatedfunction/slider.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List<Map<String, dynamic>> popularmovies = [];
  List<Map<String, dynamic>> topratedmovies = [];
  List<Map<String, dynamic>> nowplayingmovies = [];

  String popularmoviesurl =
      'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';
  String nowplayingmoviesurl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey';
  String topratedmoviesurl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey';

  Future<void> movieslist() async {
    
    var popularmoviesresponse = await http.get(Uri.parse(popularmoviesurl));
    if (popularmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(popularmoviesresponse.body);
      var popularmoviesjson = tempdata['results'];
      for (var i = 0; i < popularmoviesjson.length; i++) {
        popularmovies.add({
          'name': popularmoviesjson[i]['title'],
          'poster_path': popularmoviesjson[i]['poster_path'],
          'vote_average': popularmoviesjson[i]['vote_average'],
          'Date': popularmoviesjson[i]['release_date'],
          'id': popularmoviesjson[i]['id'],
        });
      }
    } else {
      print(popularmoviesresponse.statusCode);
    }
    var topratedmoviesresponse = await http.get(Uri.parse(topratedmoviesurl));
    if (topratedmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(topratedmoviesresponse.body);
      var topratedmoviejson = tempdata['results'];
      for (var i = 0; i < topratedmoviejson.length; i++) {
        topratedmovies.add({
          'name': topratedmoviejson[i]['title'],
          'poster_path': topratedmoviejson[i]['poster_path'],
          'vote_average': topratedmoviejson[i]['vote_average'],
          'Date': topratedmoviejson[i]['release_date'],
          'id': topratedmoviejson[i]['id'],
        });
      }
    } else {
      print(topratedmoviesresponse.statusCode);
    }
    var nowplayingmovieresponse =
        await http.get(Uri.parse(nowplayingmoviesurl));
    if (nowplayingmovieresponse.statusCode == 200) {
      var tempdata = jsonDecode(nowplayingmovieresponse.body);
      var nowplayingmoviejson = tempdata['results'];
      for (var i = 0; i < nowplayingmoviejson.length; i++) {
        nowplayingmovies.add({
          'name': nowplayingmoviejson[i]['title'],
          'poster_path': nowplayingmoviejson[i]['poster_path'],
          'vote_average': nowplayingmoviejson[i]['vote_average'],
          'Date': nowplayingmoviejson[i]['release_date'],
          'id': nowplayingmoviejson[i]['id'],
        });
      }
    } else {
      print(nowplayingmovieresponse.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: movieslist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.amber.shade400,
            ));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sliderlist(popularmovies, 'Popular Movies', 'movie', 20),
                sliderlist(topratedmovies, 'Top rated Movies', 'movie', 20),
                sliderlist(nowplayingmovies, 'Now Playing Movies', 'movie', 20),
              ],
            );
          }
        });
  }
}

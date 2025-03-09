import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movieapp/details/checker.dart';

class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  List<Map<String, dynamic>> favoriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavoriteMovies();
  }

  Future<void> fetchFavoriteMovies() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        favoriteMovies = [];
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Please log in to view your favorites.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://movieapp-backend-nine.vercel.app/api/favorite'), // เปลี่ยนเป็น URL API ของคุณ
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        setState(() {
          favoriteMovies = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          favoriteMovies = [];
          isLoading = false;
        });
        print('Failed to load favorite movies: ${response.statusCode}');
        Fluttertoast.showToast(msg: "Failed to load favorite movies.");
      }
    } catch (e) {
      setState(() {
        favoriteMovies = [];
        isLoading = false;
      });
      print('Failed to load favorite movies: $e');
      Fluttertoast.showToast(msg: "An error occurred.");
    }
  }

  Future<void> removeFavoriteMovie(int tmdbId, String tmdbType) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Fluttertoast.showToast(msg: "Please log in first");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('https://movieapp-backend-nine.vercel.app/api/favorite'), // เปลี่ยนเป็น URL API ของคุณ
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'tmdbId': tmdbId,
          'tmdbType': tmdbType,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          favoriteMovies.removeWhere((movie) => movie['tmdbid'] == tmdbId.toString() && movie['tmdbtype'] == tmdbType); // แปลง tmdbId เป็น String
        });
        Fluttertoast.showToast(msg: "Removed from Favorite");
      } else {
        print('Failed to remove favorite movie: ${response.statusCode}');
        Fluttertoast.showToast(msg: "Failed to remove favorite movie.");
      }
    } catch (e) {
      print('Failed to remove favorite movie: $e');
      Fluttertoast.showToast(msg: "An error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
      appBar: AppBar(
        elevation: MediaQuery.of(context).size.height * 0.06,
        backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
        title: Text('Favorite Movies'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : favoriteMovies.isEmpty
              ? Center(
                  child: Text(
                    "No favorite movies yet.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                      onDismissed: (direction) {
                        removeFavoriteMovie(int.parse(movie['tmdbid']), movie['tmdbtype']); // แปลง movie['tmdbid'] เป็น int
                      },
                      key: UniqueKey(),
                      child: GestureDetector(
                        onTap: () {
                          int? tmdbId = int.tryParse(movie['tmdbid'].toString());
                          if (tmdbId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => descriptioncheckui(
                                  tmdbId,
                                  movie['tmdbtype'],
                                ),
                              ),
                            );
                          } else {
                            print('Error: tmdbid is not a valid integer');
                            Fluttertoast.showToast(msg: "Invalid movie ID.");
                          }
                        },
                        child: Card(
                          child: ListTile(
                            tileColor: Color.fromRGBO(24, 24, 24, 1),
                            textColor: Colors.white,
                            title: Text(movie['tmdbname'] ?? 'No name'),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(movie['tmdbrating'].toString()),
                              ],
                            ),
                            trailing: Text(movie['tmdbtype']),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class addtofavorite extends StatefulWidget {
  final int id;
  final String type;
  final Map<String, dynamic> details;

  addtofavorite({
    required this.id,
    required this.type,
    required this.details,
  });

  @override
  _addtofavoriteState createState() => _addtofavoriteState();
}

class _addtofavoriteState extends State<addtofavorite> {
  Color? favoriteColor;
  bool isLoading = true;
  bool isFavorite = false; // เพิ่มตัวแปร state สำหรับเก็บสถานะ favorite

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  Future<void> checkFavorite() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        favoriteColor = Colors.white;
        isLoading = false;
        isFavorite = false;
      });
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
        print('Favorite data: $data'); // เพิ่ม log นี้
        final favorite = data.any((item) =>
            item['tmdbid'] == widget.id.toString() && item['tmdbtype'] == widget.type); // แปลง widget.id เป็น String

        print('Widget ID: ${widget.id}, Widget Type: ${widget.type}'); // เพิ่ม log นี้
        print('Is favorite: $favorite'); // เพิ่ม log นี้

        setState(() {
          isFavorite = favorite;
          favoriteColor = isFavorite ? Colors.red : Colors.white;
          isLoading = false;
        });
      } else {
        setState(() {
          favoriteColor = Colors.white;
          isLoading = false;
          isFavorite = false;
        });
        print('Error checking favorites: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        favoriteColor = Colors.white;
        isLoading = false;
        isFavorite = false;
      });
      print('Error checking favorites: $e');
    }
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Fluttertoast.showToast(msg: "Please login first");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isFavorite) {
        // Remove from favorite
        final response = await http.delete(
          Uri.parse('https://movieapp-backend-nine.vercel.app/api/favorite'), // เปลี่ยนเป็น URL API ของคุณ
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'tmdbId': widget.id,
            'tmdbType': widget.type,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            favoriteColor = Colors.white;
            isLoading = false;
            isFavorite = false;
          });
          Fluttertoast.showToast(msg: "Removed from Favorite");
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Failed to remove from favorite");
          print('Error removing from favorites: ${response.statusCode}');
        }
      } else {
        // Add to favorite
        final response = await http.post(
          Uri.parse('https://movieapp-backend-nine.vercel.app/api/favorite'), // เปลี่ยนเป็น URL API ของคุณ
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'tmdbId': widget.id,
            'tmdbName': widget.details['title'],
            'tmdbType': widget.type,
            'rating': widget.details['vote_average'],
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            favoriteColor = Colors.red;
            isLoading = false;
            isFavorite = true;
          });
          Fluttertoast.showToast(msg: "Added to Favorite");
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Failed to add to favorite");
          print('Error adding to favorites: ${response.statusCode}');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "An error occurred");
      print('Error toggling favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width / 2,
            child: isLoading
                ? CircularProgressIndicator()
                : Container(
                    height: 55,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 50,
                      width: 50,
                      child: IconButton(
                        icon: Icon(Icons.favorite, color: favoriteColor, size: 30),
                        onPressed: toggleFavorite,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
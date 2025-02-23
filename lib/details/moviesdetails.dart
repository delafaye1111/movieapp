import 'package:flutter/material.dart';
import 'package:movieapp/apikey/apikey.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movieapp/HomePage/HomePage.dart';
import 'package:movieapp/repeatedfunction/slider.dart';
import 'package:movieapp/repeatedfunction/trailerui.dart';
import 'package:movieapp/repeatedfunction/userreview.dart';

class MoviesDetails extends StatefulWidget {
  var id;
  MoviesDetails(this.id);

  @override
  State<MoviesDetails> createState() => _MoviesDetailsState();
}

class _MoviesDetailsState extends State<MoviesDetails> {
  List<Map<String, dynamic>> MoviesDetails = [];
  List<Map<String, dynamic>> UserReviews = [];
  List<Map<String, dynamic>> Similarmovieslist = [];
  List<Map<String, dynamic>> Recommendedmovieslist = [];
  List<Map<String, dynamic>> Movietrailerslist = [];

  List MoviesGeneres = [];

  Future<void> MoviesDetail() async {
    String moviedetailurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '?api_key=$apikey';
    String userReviewurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/reviews?api_key=$apikey';
    String similarmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';
    String recommendedmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';
    String movietrailersurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/videos?api_key=$apikey';

    var moviedetailresponse = await http.get(Uri.parse(moviedetailurl));
    if (moviedetailresponse.statusCode == 200) {
      var moviedetailjson = jsonDecode(moviedetailresponse.body);
      for (var i = 0; i < 1; i++) {
        MoviesDetails.add({
          "backdrop_path": moviedetailjson['backdrop_path'],
          "title": moviedetailjson['title'],
          "vote_average": moviedetailjson['vote_average'],
          "overview": moviedetailjson['overview'],
          "release_date": moviedetailjson['release_date'],
          "runtime": moviedetailjson['runtime'],
          "budget": moviedetailjson['budget'],
          "revenue": moviedetailjson['revenue'],
        });
      }
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGeneres.add(moviedetailjson['genres'][i]['name']);
      }
    } else {}

    /////////////////////////////User Reviews///////////////////////////////
    var UserReviewresponse = await http.get(Uri.parse(userReviewurl));
    if (UserReviewresponse.statusCode == 200) {
      var UserReviewjson = jsonDecode(UserReviewresponse.body);
      for (var i = 0; i < UserReviewjson['results'].length; i++) {
        UserReviews.add({
          "name": UserReviewjson['results'][i]['author'],
          "review": UserReviewjson['results'][i]['content'],
          "rating":
              UserReviewjson['results'][i]['author_details']['rating'] == null
                  ? "Not Rated"
                  : UserReviewjson['results'][i]['author_details']['rating']
                      .toString(),
          "avatarphoto": UserReviewjson['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  UserReviewjson['results'][i]['author_details']['avatar_path'],
          "creationdate":
              UserReviewjson['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": UserReviewjson['results'][i]['url'],
        });
      }
    } else {}
    /////////////////////////////similar movies
    var similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
    if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        Similarmovieslist.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    } else {}

    /////////////////////////////recommended movies
    var recommendedmoviesresponse =
        await http.get(Uri.parse(recommendedmoviesurl));
    if (recommendedmoviesresponse.statusCode == 200) {
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        Recommendedmovieslist.add({
          "poster_path": recommendedmoviesjson['results'][i]['poster_path'],
          "name": recommendedmoviesjson['results'][i]['title'],
          "vote_average": recommendedmoviesjson['results'][i]['vote_average'],
          "Date": recommendedmoviesjson['results'][i]['release_date'],
          "id": recommendedmoviesjson['results'][i]['id'],
        });
      }
    } else {}

    /////////////////////////////movie trailers
    var movietrailersresponse = await http.get(Uri.parse(movietrailersurl));
    if (movietrailersresponse.statusCode == 200) {
      var movietrailersjson = jsonDecode(movietrailersresponse.body);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        if (movietrailersjson['results'][i]['type'] == "Trailer") {
          Movietrailerslist.add({
            "key": movietrailersjson['results'][i]['key'],
          });
        }
      }
      Movietrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    print(Movietrailerslist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
          future: MoviesDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(FontAwesomeIcons.circleArrowLeft),
                      iconSize: 28,
                      color: Colors.white,
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false);
                          },
                          icon: Icon(FontAwesomeIcons.houseUser),
                          iconSize: 25,
                          color: Colors.white)
                    ],
                    backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                    centerTitle: false,
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: FittedBox(
                        fit: BoxFit.fill,
                        child: TrailerWatch(
                          Movietrailerslist[0]['key']
                          ,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: MoviesGeneres.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(25, 25, 25, 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(MoviesGeneres[index]),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(left: 10, top: 10),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                    MoviesDetails[0]['runtime'].toString() +
                                        ' min'),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text('Movie Story :')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text(MoviesDetails[0]['overview'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          // child: UserReview(UserReviews)
                          ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Release Date : ' +
                              MoviesDetails[0]['release_date'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Budget : ' +
                              MoviesDetails[0]['budget'].toString())),
                      sliderlist(Similarmovieslist, 'Similar Movies', 'movie',
                          Similarmovieslist.length),
                      sliderlist(Recommendedmovieslist, 'Recommended Movies',
                          'movie', Recommendedmovieslist.length),
                    ]),
                  )
                ],
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            }
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movieapp/apikey/apikey.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movieapp/HomePage/HomePage.dart';
import 'package:movieapp/repeatedfunction/slider.dart';
import 'package:movieapp/repeatedfunction/trailerui.dart';
import 'package:movieapp/repeatedfunction/userreview.dart';

class TvSeriesDetails extends StatefulWidget {
  var id;
  TvSeriesDetails(this.id);

  @override
  State<TvSeriesDetails> createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
  var tvseriesdetaildata;
  List<Map<String, dynamic>> TvSeriesDetails = [];
  List<Map<String, dynamic>> TvSeriesReviews = [];
  List<Map<String, dynamic>> similarserieslist = [];
  List<Map<String, dynamic>> recommendedserieslist = [];
  List<Map<String, dynamic>> seriestrailerslist = [];

  List MoviesGeneres = [];

  Future<void> MoviesDetail() async {
    String tvseriesdetailurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '?api_key=$apikey';
    String tvseriesreviewurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/reviews?api_key=$apikey';
    String similarseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';
    String recommendseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';
    String seriestrailersurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/videos?api_key=$apikey';

    var tvseriesdetailresponse = await http.get(Uri.parse(tvseriesdetailurl));
    if (tvseriesdetailresponse.statusCode == 200) {
      var tvseriesdetaildata = jsonDecode(tvseriesdetailresponse.body);
      for (var i = 0; i < 1; i++) {
        TvSeriesDetails.add({
          "backdrop_path": tvseriesdetaildata['backdrop_path'],
          "title": tvseriesdetaildata['title'],
          "vote_average": tvseriesdetaildata['vote_average'],
          "overview": tvseriesdetaildata['overview'],
          'status': tvseriesdetaildata['status'],
          'releasedate': tvseriesdetaildata['first_air_date'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['genres'].length; i++) {
        TvSeriesDetails.add({
          'genre': tvseriesdetaildata['genres'][i]['name'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['created_by'].length; i++) {
        TvSeriesDetails.add({
          'creator': tvseriesdetaildata['created_by'][i]['name'],
          'creatorprofile': tvseriesdetaildata['created_by'][i]['profile_path'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['seasons'].length; i++) {
        TvSeriesDetails.add({
          'season': tvseriesdetaildata['seasons'][i]['name'],
          'episode_count': tvseriesdetaildata['seasons'][i]['episode_count'],
          'total_seasons': tvseriesdetaildata['seasons'].length,
        });
      }

      print(TvSeriesDetails);
    } else {}

    /////////////////////////////User Reviews///////////////////////////////
    var tvseriesreviewresponse = await http.get(Uri.parse(tvseriesreviewurl));
    if (tvseriesreviewresponse.statusCode == 200) {
      var tvseriesreviewdata = jsonDecode(tvseriesreviewresponse.body);
      for (var i = 0; i < tvseriesreviewdata['results'].length; i++) {
        TvSeriesReviews.add({
          "name": tvseriesreviewdata['results'][i]['author'],
          "review": tvseriesreviewdata['results'][i]['content'],
          "rating": tvseriesreviewdata['results'][i]['author_details']
                      ['rating'] ==
                  null
              ? "Not Rated"
              : tvseriesreviewdata['results'][i]['author_details']['rating']
                  .toString(),
          "avatarphoto": tvseriesreviewdata['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  tvseriesreviewdata['results'][i]['author_details']
                      ['avatar_path'],
          "creationdate":
              tvseriesreviewdata['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": tvseriesreviewdata['results'][i]['url'],
        });
      }
    } else {}
    /////////////////////////////similar movies
    var similarseriesresponse = await http.get(Uri.parse(similarseriesurl));
    if (similarseriesresponse.statusCode == 200) {
      var similarseriesdata = jsonDecode(similarseriesresponse.body);
      for (var i = 0; i < similarseriesdata['results'].length; i++) {
        similarserieslist.add({
          'poster_path': similarseriesdata['results'][i]['poster_path'],
          'name': similarseriesdata['results'][i]['original_name'],
          'vote_average': similarseriesdata['results'][i]['vote_average'],
          'id': similarseriesdata['results'][i]['id'],
          'Date': similarseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    /////////////////////////////recommended movies
    var recommendseriesresponse = await http.get(Uri.parse(recommendseriesurl));
    if (recommendseriesresponse.statusCode == 200) {
      var recommendseriesdata = jsonDecode(recommendseriesresponse.body);
      for (var i = 0; i < recommendseriesdata['results'].length; i++) {
        recommendedserieslist.add({
          'poster_path': recommendseriesdata['results'][i]['poster_path'],
          'name': recommendseriesdata['results'][i]['original_name'],
          'vote_average': recommendseriesdata['results'][i]['vote_average'],
          'id': recommendseriesdata['results'][i]['id'],
          'Date': recommendseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    /////////////////////////////movie trailers
    var tvseriestrailerresponse = await http.get(Uri.parse(seriestrailersurl));
    if (tvseriestrailerresponse.statusCode == 200) {
      var tvseriestrailerdata = jsonDecode(tvseriestrailerresponse.body);
      // print(tvseriestrailerdata);
      for (var i = 0; i < tvseriestrailerdata['results'].length; i++) {
        //add only if type is trailer
        if (tvseriestrailerdata['results'][i]['type'] == "Trailer") {
          seriestrailerslist.add({
            'key': tvseriestrailerdata['results'][i]['key'],
          });
        }
      }
      seriestrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    print(seriestrailerslist);
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
                    expandedHeight: MediaQuery.of(context).size.height * 0.35,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: FittedBox(
                        fit: BoxFit.fill,
                        child: TrailerWatch(
                          seriestrailerslist[0]['key'],
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
                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.all(10),
                          //       margin: EdgeInsets.only(left: 10, top: 10),
                          //       height: 40,
                          //       decoration: BoxDecoration(
                          //         color: Color.fromRGBO(25, 25, 25, 1),
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //           TvSeriesDetails[0]['runtime'].toString() +
                          //               ' min'),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 12),
                          child: Text("Series Overview : ")),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child:
                              Text(TvSeriesDetails[0]['overview'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: UserReview(TvSeriesReviews)),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child:
                              Text("Status : ${TvSeriesDetails[0]['status']}")),
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text(
                              "Total Seasons : ${TvSeriesDetails[TvSeriesDetails.length - 1]['total_seasons']}")),
                      //airdate
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text(
                              "Release date : ${TvSeriesDetails[0]['releasedate']}")),
                      sliderlist(similarserieslist, 'Similar Series', 'tv',
                          similarserieslist.length),
                      sliderlist(recommendedserieslist, 'Recommended Series',
                          'tv', recommendedserieslist.length),
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

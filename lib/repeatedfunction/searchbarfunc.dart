import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movieapp/details/checker.dart';
import 'package:movieapp/apikey/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class searchbarfunc extends StatefulWidget {
  const searchbarfunc({super.key});

  @override
  State<searchbarfunc> createState() => _searchbarfuncState();
}

class _searchbarfuncState extends State<searchbarfunc> {
  List<Map<String, dynamic>> searchresult = [];
  final TextEditingController searchText = TextEditingController();
  bool showList = false;
  var vall;

  Future<void> searchListFunction(String val) async {
    var searchurl =
        'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$val';
    var searchresponse = await http.get(Uri.parse(searchurl));
    if (searchresponse.statusCode == 200) {
      var tempdata = jsonDecode(searchresponse.body);
      var searchjson = tempdata['results'];
      for (var i = 0; i < searchjson.length; i++) {
        //only add value if all are present
        if (searchjson[i]['id'] != null &&
            searchjson[i]['poster_path'] != null &&
            searchjson[i]['vote_average'] != null &&
            searchjson[i]['media_type'] != null) {
          searchresult.add({
            'id': searchjson[i]['id'],
            'poster_path': searchjson[i]['poster_path'],
            'vote_average': searchjson[i]['vote_average'],
            'media_type': searchjson[i]['media_type'],
            'popularity': searchjson[i]['popularity'],
            'overview': searchjson[i]['overview'],
          });

          if (searchresult.length > 20) {
            searchresult.removeRange(20, searchresult.length);
          }
        } else {}
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showList = !showList;
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                  autofocus: false,
                  controller: searchText,
                  onSubmitted: (value) {
                    searchresult.clear();
                    setState(() {
                      vall = value;
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  onChanged: (value) {
                    searchresult.clear();
                    setState(() {
                      vall = value;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            webBgColor: "#000000",
                            webPosition: 'center',
                            webShowClose: true,
                            msg: 'Search Cleared',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          searchText.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.amber.withOpacity(0.6),
                      ),
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.amber),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                    border: InputBorder.none,
                  )),
            ),
            SizedBox(height: 5),
            if (searchText.text.length > 0)
              FutureBuilder(
                future: searchListFunction(vall),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: searchresult.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => descriptioncheckui(
                                            searchresult[index]['id'],
                                            searchresult[index]['media_type'],
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(20, 20, 20, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        120, // กำหนดขนาดของ Container แสดงรูปภาพ
                                    height: 180,
                                    child: searchresult[index]['poster_path'] !=
                                            null // check null
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w500${searchresult[index]['poster_path']}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Center(
                                                    child: Text(
                                                        'Image Error')), // show error text
                                          )
                                        : Center(
                                            child: Text(
                                                'No Image')), // show no image text
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              '${searchresult[index]['media_type']}',
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${searchresult[index]['vote_average']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: 30,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .people_outline_sharp,
                                                          color: Colors.amber,
                                                          size: 10),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                          child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: Text(
                                                                '${searchresult[index]['popularity']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ))),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 85,
                                            child: Text(
                                              '${searchresult[index]['overview']}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(color: Colors.amber));
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}

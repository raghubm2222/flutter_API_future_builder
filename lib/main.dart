import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todos',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<dynamic>> getData() async {
    var response = await http.get(Uri.parse(
        'http://www.json-generator.com/api/json/get/coBkVexrsi?indent=2'));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Members')),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Loading...'));
          } else {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (conext) =>
                              DetailsPage(userDetails: data[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://source.unsplash.com/1600x900/?profile',
                        ),
                      ),
                      title: Text(data[index]['name'].toString()),
                      subtitle: Text(
                        data[index]['phone']
                            .replaceAll('(', '')
                            .replaceAll(')', '')
                            .replaceAll('-', '')
                            .replaceAll(' ', '')
                            .substring(3, 13),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No Data Foound'));
            }
          }
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final dynamic userDetails;
  const DetailsPage({Key? key, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDetails['name'].toString(),
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  userDetails['phone']
                      .replaceAll('(', '')
                      .replaceAll(')', '')
                      .replaceAll('-', '')
                      .replaceAll(' ', '')
                      .substring(3, 13),
                  style: TextStyle(fontSize: 14.0, color: Colors.white70),
                )
              ],
            ),
            CircleAvatar(
              radius: 16.0,
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/1600x900/?profile,person',
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: ListView(
          children: [
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userDetails['email'].toString()),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userDetails['gender'].toString().toUpperCase()),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Age', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userDetails['age'].toString()),
              ],
            ),
            SizedBox(height: 15.0),
            Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 2.0),
            Text(userDetails['address']),
            SizedBox(height: 15.0),
            Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 2.0),
            Text(userDetails['about'], textAlign: TextAlign.justify),
            SizedBox(height: 15.0),
            Text('Friends', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 2.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userDetails['friends'].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(userDetails['friends'][index]['name']),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

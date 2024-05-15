import 'package:flutter/material.dart';

import '../../services/admin_firebase.dart';





class TOSPage extends StatefulWidget {
  @override
  _TOSPageState createState() => _TOSPageState();
}

class _TOSPageState extends State<TOSPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관 및 정책'),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: AdminFirebase().tos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasData) {
                List<Map<String, String>> tos = snapshot.data!;
                return ListView.builder(
                  itemCount: tos.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(tos[index]["Term"]!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text(tos[index]["Policy"]!, style: TextStyle(fontSize: 15),),
                        const SizedBox(height: 32.0),
                      ]
                    );
                  },
                );
              } else {
                return Text('No data available.');
              }
          }
        },
      )
    );
  }
}

/*
              Text('약관', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(terms, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 32.0),
              Text('개인정보 보호 정책', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(policy, style: TextStyle(fontSize: 16.0)),
              */
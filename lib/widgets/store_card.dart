import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../map.dart';
import '../model/store_model.dart';
import '../screens/store_menu_page/store_menu_page.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 100,
              height: 60,
              child: Image.network(
                store.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          title: AutoSizeText(
            store.storeName,
            maxLines: 1,
          ),
          subtitle: AutoSizeText(
            store.subscript,
            maxLines: 1,
          ),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(store.cuisineType),
              FutureBuilder<String>(
                future: calDist(store.latitude, store.longitude),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Calculating...');
                  } else if (snapshot.hasError) {
                    return Text('Error');
                  } else {
                    return Text(snapshot.data ?? 'Unknown distance');
                  }
                },
              )
      ],
    ),
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => StoreMenuPage(store: store),
    ),
    );
    },
    ),
    );
  }
}

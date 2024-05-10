import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../map.dart';
import '../../../model/store_model.dart';
import '../../../services/store_service.dart';
import '../../store_menu_page/store_menu_page.dart';

class StoreListWidget extends StatelessWidget {
  final String cuisineType; // 가게 종류

  const StoreListWidget({Key? key, required this.cuisineType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Store>>(
      stream: StoreService().getStoresByCuisineType(cuisineType),
      // 선택한 가게 종류에 따라 가게 목록을 가져옴
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Store> stores = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            Store store = stores[index];
            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 100,
                    height: 60,
                    child: Image.network(
                      stores[index].image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: AutoSizeText(
                  stores[index].storeName,
                  maxLines: 1,
                ),
                subtitle: AutoSizeText(
                  stores[index].subscript,
                  maxLines: 1,
                ),
                trailing: Column
                  (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(stores[index].cuisineType),
                    Text(calDist(
                        dummy, stores[index].latitude, stores[index].longitude))
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
          },
        );
      },
    );
  }
}

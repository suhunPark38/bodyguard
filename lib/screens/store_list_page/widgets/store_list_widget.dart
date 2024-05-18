import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../map.dart';
import '../../../model/store_model.dart';
import '../../../services/store_service.dart';
import '../../../widgets/store_card.dart';
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
            return StoreCard(store: store);
          },
        );
      },
    );
  }
}

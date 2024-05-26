import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_provider.dart';
import '../../../providers/shopping_provider.dart';
import '../../../services/store_service.dart';
import '../../store_list_page/store_list_page.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return ExpansionTile(
      title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

        Text(
          "카테고리",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
      initiallyExpanded: searchProvider.isListViewVisible,
      onExpansionChanged: (bool expanded) {
        searchProvider.toggleListViewVisibility();
      },
      children: searchProvider.cuisineTypes.map((cuisineType) {
        Future<String?> getImageUrl() async {
          return await StoreService()
              .getFirstStoreImageByCuisineType(cuisineType);
        }

        return ListTile(
          title: Text(cuisineType),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: SizedBox(
              width: 40,
              height: 40,
              child: FutureBuilder<String?>(
                future: getImageUrl(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Image.network(
                      snapshot.data ?? 'placeholder_image_url',
                      fit: BoxFit.fill,
                    );
                  }
                },
              ),
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Provider.of<ShoppingProvider>(context, listen: false)
                .setCurrentStoreTabIndex(
                    searchProvider.cuisineTypes.indexOf(cuisineType));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoreListPage(),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

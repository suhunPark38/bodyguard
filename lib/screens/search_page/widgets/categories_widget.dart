import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_provider.dart';
import '../../../providers/shopping_provider.dart';
import '../../store_list_page/store_list_page.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    if (searchProvider.cuisineTypes.isEmpty ||
        searchProvider.cuisineTypeImages.isEmpty ||
        searchProvider.cuisineTypes.length !=
            searchProvider.cuisineTypeImages.length) {
      return const Center(child: CircularProgressIndicator());
    }

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
        ],
      ),
      onExpansionChanged: (bool expanded) {
        searchProvider.toggleListViewVisibility();
      },
      children: searchProvider.cuisineTypes.map((cuisineType) {
        int index = searchProvider.cuisineTypes.indexOf(cuisineType);
        String imageUrl = searchProvider.cuisineTypeImages[index];

        return ListTile(
          title: Text(cuisineType),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Provider.of<ShoppingProvider>(context, listen: false)
                .setCurrentStoreTabIndex(index);
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

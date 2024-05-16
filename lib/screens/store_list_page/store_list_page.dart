import 'package:bodyguard/providers/shopping_provider.dart';
import 'package:bodyguard/screens/store_list_page/widgets/store_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_home_page/my_home_page.dart';
import '../shopping_page/shopping_page.dart';
import '../../services/store_service.dart';

class StoreListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: StoreService().getAllCuisineTypes(), // 모든 가게 종류 가져오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          List<String> cuisineTypes = snapshot.data!;
          return DefaultTabController(
            length: cuisineTypes.length,
            initialIndex: Provider.of<ShoppingProvider>(context, listen: false)
                .currentStoreTabIndex,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('가게'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                                  initialIndex: 0,
                                )),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                  ),
                ],
                bottom: TabBar(
                  tabs: cuisineTypes.map((type) => Tab(text: type)).toList(),
                ),
              ),
              body: TabBarView(
                children: cuisineTypes.map((type) {
                  return StoreListWidget(cuisineType: type);
                }).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Provider.of<ShoppingProvider>(context, listen: false)
                      .setCurrentShoppingTabIndex(0);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                              initialIndex: 3,
                            )),
                    (route) => false,
                  );
                },
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          );
        }
      },
    );
  }
}

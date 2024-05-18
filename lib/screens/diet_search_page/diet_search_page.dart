import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/diet_data_provider.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/diet_data_list_view.dart';

class DietSearchPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  DietSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("식단 기록"),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              controller: controller,
              hintText: "기록할 음식을 입력하세요",
              onChanged: (value) {},
              onSubmitted: (value) async {
                Provider.of<DietDataProvider>(context, listen: false)
                    .fetchDietData(value);
              },
              onPressed: () {
                _setControllerText('');
              },
            ),
            const Expanded(
              child: DietDataListView(),
            ),
          ],
        ));
  }

  void _setControllerText(String text) {
    controller.text = text;
  }
}

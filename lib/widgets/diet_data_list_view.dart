import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/fetched_diet_data.dart';
import '../providers/diet_data_provider.dart';
import '../screens/diet_page/widgets/diet_input_dialog.dart';

class DietDataListView extends StatelessWidget {
  const DietDataListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DietDataProvider>(
      builder: (context, provider, _) {
        if (provider.dietDataList.isEmpty) {
          return const Center(child: Text("데이터가 없습니다."));
        } else {
          return ListView.builder(
            itemCount: provider.dietDataList.length,
            itemBuilder: (context, index) {
              final fetchedData = provider.dietDataList[index];
              return ListTile(
                title: Text(fetchedData.DESC_KOR),
                subtitle: Text(fetchedData.NUTR_CONT1),
                leading: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    _showDietDetail(context, fetchedData);
                  },
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () =>
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DietInputDialog(selectedData: fetchedData),
                    ),
              );
            },
          );
        }
      },
    );
  }

  void _showDietDetail(BuildContext context, FetchedDietData selectedData) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(selectedData.DESC_KOR),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('업체명'),
                    subtitle: Text(selectedData.MAKER_NAME),
                  ),
                  ListTile(
                    title: Text('열량'),
                    subtitle: Text('${selectedData.NUTR_CONT1}kcal'),
                  ),
                  ListTile(
                    title: Text('탄수화물'),
                    subtitle: Text('${selectedData.NUTR_CONT2}g'),
                  ),
                  ListTile(
                    title: Text('단백질'),
                    subtitle: Text('${selectedData.NUTR_CONT3}g'),
                  ),
                  ListTile(
                    title: Text('지방'),
                    subtitle: Text('${selectedData.NUTR_CONT4}g'),
                  ),
                  ListTile(
                    title: Text('당류'),
                    subtitle: Text('${selectedData.NUTR_CONT5}g'),
                  ),
                  ListTile(
                    title: Text('나트륨'),
                    subtitle: Text('${selectedData.NUTR_CONT6}mg'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("닫기"),
              ),
            ],
          ),
    );
  }
}
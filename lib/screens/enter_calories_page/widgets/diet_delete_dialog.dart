import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../database/config_database.dart';
import '../../../providers/diet_provider.dart';

class DietDeleteDialog extends StatelessWidget {
  final BuildContext context;
  final DietData dietData;

  const DietDeleteDialog({
    Key? key,
    required this.context,
    required this.dietData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DietProvider dietProvider = context.read<DietProvider>();

    return AlertDialog(
      title: Text('삭제 확인'),
      content: Text('정말 이 식단 정보를 삭제하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('아니요'),
        ),
        TextButton(
          onPressed: () {
            dietProvider.notifyDeleteDiet(dietData.dietId);
            Navigator.pop(context); // 다이얼로그 닫기
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
          child: Text('예'),
        ),
      ],
    );
  }
}
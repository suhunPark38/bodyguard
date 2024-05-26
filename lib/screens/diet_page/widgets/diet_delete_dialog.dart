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
      title:
          const Text('식단 삭제', style: TextStyle(fontWeight: FontWeight.w500)),
      content: Text('정말 ${dietData.menuName}을(를) 삭제하시겠습니까?'),
      actions: [
        FilledButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('취소하기', style: TextStyle(color: Colors.black)),
        ),
        FilledButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            dietProvider.notifyDeleteDiet(dietData.dietId);
            Navigator.pop(context);
          },
          child: const Text('삭제하기'),
        ),
      ],
    );
  }
}

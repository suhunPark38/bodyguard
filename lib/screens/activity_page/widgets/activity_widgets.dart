import 'package:flutter/material.dart';

Widget buildInfoColumn({required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      Text(
        value,
        style: TextStyle(fontSize: 15),
      ),
    ],
  );
}

Widget buildActivityRow({
  required IconData icon,
  required String label,
  required double caloriesBurned,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, size: 60),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 $label',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 5),
          Text(
            '${caloriesBurned.toStringAsFixed(2)} kcal 소모',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );
}

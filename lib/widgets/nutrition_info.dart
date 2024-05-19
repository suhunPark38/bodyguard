import 'package:bodyguard/model/diet_record.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class NutritionInfo extends StatelessWidget {
  const NutritionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DietRecord total = context.watch<DietProvider>().totalNutritionalInfo;
    double totalAmount = total.getTotalAmount();

    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: constraints.maxWidth * 0.5,
            width: constraints.maxWidth * 0.5,
            child: PieChart(
              PieChartData(
                sections: _buildPieChartSections(total, totalAmount),
                centerSpaceRadius: 35,
                sectionsSpace: 4,
              ),
            ),
          ),
          _buildLegend(total),
        ],
      );
    });
  }

  List<PieChartSectionData> _buildPieChartSections(DietRecord total, double totalAmount) {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: total.carbohydrates,
        title: '${(total.carbohydrates / totalAmount * 100).toStringAsFixed(1)}%',
        radius: 35,
        titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: total.protein,
        title: '${(total.protein / totalAmount * 100).toStringAsFixed(1)}%',
        radius: 35,
        titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.brown.shade800,
        value: total.fat,
        title: '${(total.fat / totalAmount * 100).toStringAsFixed(1)}%',
        radius: 35,
        titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  Widget _buildLegend(DietRecord total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('탄수화물', Colors.green, total.carbohydrates),
        _buildLegendItem('단백질', Colors.orangeAccent, total.protein),
        _buildLegendItem('지방', Colors.brown.shade800, total.fat),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                '${value.toStringAsFixed(1)}g',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

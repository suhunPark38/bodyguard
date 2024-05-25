import 'package:flutter/material.dart';

import '../../../providers/shopping_provider.dart';
import '../../../utils/format_util.dart';
import '../../../widgets/nutrient_info_button.dart';

class PaymentTabWidget extends StatelessWidget {
  final ShoppingProvider provider;

  const PaymentTabWidget({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (var entry in provider.storeMenuMap.entries)
                  Column(
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      for (var menu in entry.value)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.network(
                                      menu.image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        menu.menuName,
                                        style: const TextStyle(fontSize: 15),
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.left,
                                      ),
                                      NutrientInfoButton(size: 15, menu: menu),
                                    ]),
                                    Text(
                                      '개당 ${formatNumber(menu.price)}원',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${formatNumber(provider.menuQuantities[menu]! * menu.price)}원',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        provider.removeMenu(menu);
                                      },
                                      child: const Icon(Icons.close),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            if (provider.menuQuantities[menu]! >
                                                1) {
                                              provider.updateMenuQuantity(
                                                  menu.id,
                                                  provider.menuQuantities[
                                                          menu]! -
                                                      1);
                                              provider.calculateTotalPrice();
                                            }
                                          },
                                        ),
                                        Text(
                                          '${provider.menuQuantities[menu]}',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            int currentQuantity = (provider.menuQuantities[menu] ?? 1);
                                            if (currentQuantity < 100) {
                                              provider.updateMenuQuantity(menu.id, currentQuantity + 1);
                                              provider.calculateTotalPrice();
                                            }
                                          },
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

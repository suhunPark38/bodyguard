import 'package:flutter/material.dart';
import '../store_list_page/store_list_page.dart';
import '../../map.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String? _deliveryType;
  int _quantity = 1;

  void _handleDeliveryTypeChange(String? value) {
    setState(() {
      _deliveryType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('쇼핑'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: '결제하기'),
              Tab(text: '결제 내역'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TabBarView(
            children: [
              CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "더미 가게",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 130,
                              height: 20,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Widget mapPage = await MapRun();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => mapPage,
                                    ),
                                  );
                                },
                                child: const Text('영양성분 확인하기',
                                    style: TextStyle(fontSize: 10)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '더미 음식',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      '개당 10,000원',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      '10,000원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(Icons.close),
                                    ),
                                    const SizedBox(height: 10),
                                    StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        // 초기 갯수 설정
                                        return Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  if (_quantity > 1) {
                                                    _quantity--;
                                                  }
                                                });
                                              },
                                            ),
                                            Text(
                                              '$_quantity',
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                setState(() {
                                                  _quantity++;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Radio(
                                      value: 'delivery',
                                      groupValue: _deliveryType,
                                      onChanged: _handleDeliveryTypeChange,
                                    ),
                                    const Text("배달"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 'takeaway',
                                      groupValue: _deliveryType,
                                      onChanged: _handleDeliveryTypeChange,
                                    ),
                                    const Text("포장"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 90,
                              height: 20,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Widget mapPage = await MapRun();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => mapPage,
                                    ),
                                  );
                                },
                                child: const Text('가게 위치',
                                    style: TextStyle(fontSize: 10)),
                              ),
                            ),
                            SizedBox(
                              width: 90,
                              height: 20,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StoreListPage()),
                                  );
                                },
                                child: const Text('메뉴 담기',
                                    style: TextStyle(fontSize: 10)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "결제 금액",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "10,000원",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.maxFinite,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('10,000원 결제하기'),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ]),
              const Center(
                child: Text('결제 내역이 여기에 표시됩니다.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

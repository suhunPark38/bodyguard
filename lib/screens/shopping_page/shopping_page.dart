import 'package:flutter/material.dart';
import '../../model/storeMenu.dart';
import '../../model/storeModel.dart';
import '../../map.dart';

class ShoppingPage extends StatefulWidget {
  final Store? selectedStore;
  final List<StoreMenu>? selectedMenus;

  const ShoppingPage({
    Key? key,
    this.selectedStore,
    this.selectedMenus,
  }) : super(key: key);

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String? _deliveryType;
  Map<StoreMenu, int> _menuQuantities = {}; // 각 메뉴의 개수를 저장할 맵

  List<StoreMenu>? _selectedMenus;
  int? _totalPrice;

  @override
  void initState() {
    super.initState();

    _selectedMenus = widget.selectedMenus;
    _selectedMenus?.forEach((menu) {
      _menuQuantities[menu] = 1; // 각 메뉴의 개수를 기본값으로 설정
    });

    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    int totalPrice = 0;
    if (_selectedMenus != null) {
      for (var menu in _selectedMenus!) {
        totalPrice += (menu.price * _menuQuantities[menu]!); // 개수에 따라 가격 계산
      }
    }
    setState(() {
      _totalPrice = totalPrice;
    });
  }

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
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (widget.selectedStore != null)
                            Text(
                              widget.selectedStore!.StoreName,
                              style: TextStyle(fontSize: 20),
                            ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          if (_selectedMenus != null)
                            for (var menu in _selectedMenus!)
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            menu.menuName,
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            '개당 ${menu.price}원',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '${_menuQuantities[menu]! * menu.price}원',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedMenus!.remove(menu);
                                                _calculateTotalPrice();
                                              });
                                            },
                                            child: const Icon(Icons.close),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon:
                                                const Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_menuQuantities[menu]! >
                                                        1) {
                                                      _menuQuantities[menu] = _menuQuantities[menu]! - 1;; // 개수를 감소
                                                      _calculateTotalPrice();
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                '${_menuQuantities[menu]}',
                                                style:
                                                const TextStyle(fontSize: 15),
                                              ),
                                              IconButton(
                                                icon:
                                                const Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    _menuQuantities[menu] = (_menuQuantities[menu] ?? 1) + 1; // 개수를 증가
                                                    _calculateTotalPrice();
                                                  });
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
                                  child: const Text(
                                    '가게 위치',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                height: 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '메뉴 담기',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "결제 금액",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$_totalPrice원",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.maxFinite,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('$_totalPrice원 결제하기'),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

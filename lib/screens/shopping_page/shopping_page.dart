import 'package:flutter/material.dart';
import '../../model/payment.dart';
import '../../model/storeMenu.dart';
import '../../map.dart';
import '../../services/payment_service.dart';
import 'package:uuid/uuid.dart';



class ShoppingPage extends StatefulWidget {
  final List<StoreMenu>? selectedMenus;

  const ShoppingPage({
    Key? key,
    this.selectedMenus,
  }) : super(key: key);

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String? _deliveryType;
  final Map<StoreMenu, int> _menuQuantities = {};
  List<StoreMenu>? _selectedMenus;
  int? _totalPrice;
  Map<String, List<StoreMenu>> _storeMenuMap = {};

  @override
  void initState() {
    super.initState();
    _selectedMenus = widget.selectedMenus;
    _selectedMenus?.forEach((menu) {
      _menuQuantities[menu] = 1;
      if (_storeMenuMap.containsKey(menu.storeName)) {
        _storeMenuMap[menu.storeName]!.add(menu);
      } else {
        _storeMenuMap[menu.storeName] = [menu];
      }
    });

    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    int totalPrice = 0;
    if (_selectedMenus != null) {
      for (var menu in _selectedMenus!) {
        totalPrice += (menu.price * _menuQuantities[menu]!);
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

  Future<void> _completePayment() async {
    final payment = Payment(
      orderId: const Uuid().v4(),
      currency: 'KRW',
      status: PaymentStatus.completed,
      timestamp: DateTime.now(),
      storeNames: _selectedMenus!.map((menu) => menu.storeName).toList(),
      menus: _selectedMenus!,
      deliveryType: _deliveryType!,
    );

    try {
      await PaymentService().addPayment(payment);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제가 완료되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 정보 저장 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<List<Payment>> fetchPayments() async {
    try {
      List<Payment> payments = await PaymentService().getPayments();
      return payments;
    } catch (e) {
      print('결제 내역을 가져오는 중 오류가 발생했습니다: $e');
      return [];
    }
  }

  void _removeMenu(StoreMenu menu) {
    setState(() {
      _selectedMenus!.remove(menu);

      if (_storeMenuMap.containsKey(menu.storeName)) {
        _storeMenuMap[menu.storeName]!.remove(menu);
        if (_storeMenuMap[menu.storeName]!.isEmpty) {
          _storeMenuMap.remove(menu.storeName);
        }
      }

      _calculateTotalPrice();
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
                          for (var entry in _storeMenuMap.entries)
                            Column(
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(fontSize: 20),
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                for (var menu in entry.value)
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
                                                  _removeMenu(menu);
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
                                                          _menuQuantities[menu] =
                                                              _menuQuantities[
                                                              menu]! -
                                                                  1;
                                                          _calculateTotalPrice();
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    '${_menuQuantities[menu]}',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () {
                                                      setState(() {
                                                        _menuQuantities[menu] =
                                                            (_menuQuantities[
                                                            menu] ??
                                                                1) +
                                                                1;
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
                              ],
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
                              const Text(
                                "결제 금액",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$_totalPrice원",
                                style: const TextStyle(
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
                              onPressed: () {
                                setState(() {
                                  if (_deliveryType != null) {
                                    _completePayment();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                '배달 또는 포장을 선택해주세요.')));
                                  }
                                });
                              },
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
              FutureBuilder<List<Payment>>(
                future: fetchPayments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('결제 내역을 가져오는 중 오류가 발생했습니다.'),
                    );
                  } else {
                    final payments = snapshot.data ?? [];
                    if (payments.isEmpty) {
                      return Center(
                        child: Text('결제 내역이 없습니다.'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          return ListTile(
                            title: Text('주문 ID: ${payment.orderId}'),
                            subtitle: Text(
                                '결제 상태: ${payment.status.toString().split('.').last} 결제 일시: ${payment.timestamp}'),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

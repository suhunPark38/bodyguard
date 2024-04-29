import 'package:flutter/material.dart';
import '../../model/payment.dart';
import '../../model/storeMenu.dart';
import '../../model/storeModel.dart';
import '../../map.dart';
import '../../services/payment_service.dart';
import 'package:uuid/uuid.dart';


class ShoppingPage extends StatefulWidget {
  final List<Store>? selectedStores;
  final List<StoreMenu>? selectedMenus;

  const ShoppingPage({
    Key? key,
    this.selectedStores,
    this.selectedMenus,
  }) : super(key: key);

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String? _deliveryType;
  final Map<StoreMenu, int> _menuQuantities = {}; // 각 메뉴의 개수를 저장할 맵

  List<Store>? _selectedStores;
  List<StoreMenu>? _selectedMenus;
  int? _totalPrice;

  @override
  void initState() {
    super.initState();
    _selectedStores= widget.selectedStores;
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
  Future<void> _completePayment() async {
    // 결제 정보 생성
    final payment = Payment(
      orderId: const Uuid().v4(), // 고유 주문 ID 생성 또는 Firebase에서 생성된 ID 사용
      currency: 'KRW', // 통화 설정
      status: PaymentStatus.completed, // 결제 상태 설정
      timestamp: DateTime.now(), // 현재 시간
      storeNames: _selectedStores!.map((store) => store.StoreName).toList(), // 선택된 가게 목록
      menus: _selectedMenus!, // 선택된 메뉴 목록
      deliveryType: _deliveryType!,
    );

    // 결제 정보 저장
    try {
      await PaymentService().addPayment(payment);
      // 결제 완료 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제가 완료되었습니다.')),
      );
    } catch (e) {
      // 결제 정보 저장 중 오류 발생 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 정보 저장 중 오류가 발생했습니다.')),
      );
    }
  }
  Future<List<Payment>> fetchPayments() async {
    try {
      List<Payment> payments = await PaymentService().getPayments();
      // 결제 내역 가져오기 성공
      // 가져온 결제 내역을 반환
      return payments;
    } catch (e) {
      // 결제 내역 가져오기 실패
      // 오류 처리
      print('결제 내역을 가져오는 중 오류가 발생했습니다: $e');
      // 오류가 발생했으므로 빈 리스트 반환
      return [];
    }
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
                          if (_selectedStores != null)
                            for (var stores in _selectedStores!)
                              Text(
                                "${stores.StoreName}",
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
                                  if(_deliveryType!=null) {
                                    _completePayment();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('배달 또는 포장을 선택해주세요.'),
                                    ));
                                  }
                                });
                                //여기에 결제확인 로직이 필요함 배달 타입 라디오버튼 예시

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
              // 결제 내역 탭
              FutureBuilder<List<Payment>>(
                future: fetchPayments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 로딩 상태일 때 표시할 위젯
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // 오류 발생 시 표시할 위젯
                    return Center(
                      child: Text('결제 내역을 가져오는 중 오류가 발생했습니다.'),
                    );
                  } else {
                    // 데이터를 성공적으로 가져온 경우 결제 내역을 표시하는 위젯
                    final payments = snapshot.data ?? [];
                    if (payments.isEmpty) {
                      // 결제 내역이 없는 경우 표시할 위젯
                      return Center(
                        child: Text('결제 내역이 없습니다.'),
                      );
                    } else {
                      // 결제 내역이 있는 경우 리스트로 표시
                      return ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          return ListTile(
                            title: Text('주문 ID: ${payment.orderId}'),
                            subtitle: Text('결제 상태: ${payment.status.toString().split('.').last} 결제 일시: ${payment.timestamp}'),
                            // 다른 결제 정보도 표시하고 싶은 경우 여기에 추가
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

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bodyguard/model/ad_model.dart';
import 'package:bodyguard/services/ad_service.dart';
import 'package:bodyguard/services/store_service.dart';
import 'package:bodyguard/screens/store_menu_page/store_menu_page.dart';

import '../../../model/store_model.dart';

class AdCarousel extends StatelessWidget {
  final AdService adService = AdService();
  final StoreService storeService = StoreService();

  AdCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ad>>(
      future: adService.fetchAds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('광고를 불러오는 중 오류가 발생했습니다.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('광고가 없습니다.'));
        } else {
          final ads = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              height: 210,
              aspectRatio: 16 / 9,
              viewportFraction: 0.85,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              onPageChanged: ((index, reason) {}),
            ),
            items: ads.map((ad) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () async {
                      Store? store =
                          await storeService.getStoreByName(ad.storeName);
                      if (store != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreMenuPage(store: store),
                          ),
                        );
                      } else {
                        // store가 null인 경우에 대한 처리 (예: 에러 메시지 표시)
                        print('해당 가게를 찾을 수 없습니다.');
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ad.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}

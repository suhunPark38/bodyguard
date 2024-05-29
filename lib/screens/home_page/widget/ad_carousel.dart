import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:bodyguard/providers/ad_provider.dart';

import '../../../model/store_model.dart';
import '../../../services/store_service.dart';
import '../../store_menu_page/store_menu_page.dart';

class AdCarousel extends StatelessWidget {
  final StoreService storeService = StoreService();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdProvider>(
      builder: (context, adProvider, _) {
        if (adProvider.ads.isEmpty) {
          adProvider.fetchAds(); // 데이터 가져오기
          return const Center(child: CircularProgressIndicator());
        } else {
          final ads = adProvider.ads;
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

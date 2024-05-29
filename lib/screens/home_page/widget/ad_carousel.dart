import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:bodyguard/providers/ad_provider.dart';

class AdCarousel extends StatelessWidget {
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
                      // onTap 이벤트 처리
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

class FetchedDietData {

  /*
  1	NUM	번호
2	FOOD_CD	식품코드
3	SAMPLING_REGION_NAME	지역명
4	SAMPLING_MONTH_NAME	채취월
5	SAMPLING_REGION_CD	지역코드
6	SAMPLING_MONTH_CD	채취월코드
7	GROUP_NAME	식품군
8	DESC_KOR	식품이름
9	RESEARCH_YEAR	조사년도
10	MAKER_NAME	제조사명
11	SUB_REF_NAME	자료출처
12	SERVING_SIZE	총내용량
13	SERVING_UNIT	총내용량단위
14	NUTR_CONT1	열량(kcal)(1회제공량당)
15	NUTR_CONT2	탄수화물(g)(1회제공량당)
16	NUTR_CONT3	단백질(g)(1회제공량당)
17	NUTR_CONT4	지방(g)(1회제공량당)
18	NUTR_CONT5	당류(g)(1회제공량당)
19	NUTR_CONT6	나트륨(mg)(1회제공량당)
20	NUTR_CONT7	콜레스테롤(mg)(1회제공량당)
21	NUTR_CONT8	포화지방산(g)(1회제공량당)
22	NUTR_CONT9	트랜스지방(g)(1회제공량당)
  */


  final String DESC_KOR, MAKER_NAME, SERVING_SIZE, SERVING_UNIT, NUTR_CONT1,
      NUTR_CONT2, NUTR_CONT3
  , NUTR_CONT4, NUTR_CONT5, NUTR_CONT6, NUTR_CONT7, NUTR_CONT8, NUTR_CONT9;

  FetchedDietData({
    required this.DESC_KOR,
    required this.MAKER_NAME,
    required this.SERVING_SIZE,
    required this.SERVING_UNIT,
    required this.NUTR_CONT1,
    required this.NUTR_CONT2,
    required this.NUTR_CONT3,
    required this.NUTR_CONT4,
    required this.NUTR_CONT5,
    required this.NUTR_CONT6,
    required this.NUTR_CONT7,
    required this.NUTR_CONT8,
    required this.NUTR_CONT9
  });

  factory FetchedDietData.fromJson(Map<String, dynamic> json){
    return FetchedDietData(
      DESC_KOR: json['DESC_KOR'].isEmpty ? "미확인" : json['DESC_KOR'],
      MAKER_NAME: json['MAKER_NAME'].isEmpty ? "미확인" : json['MAKER_NAME'],
      SERVING_SIZE: json['SERVING_SIZE'].isEmpty ? "미확인" : json['SERVING_SIZE'],
      SERVING_UNIT: json['SERVING_UNIT'].isEmpty ? "미확인" : json['SERVING_UNIT'],
      NUTR_CONT1: json['NUTR_CONT1'].isEmpty ? "미확인" : json['NUTR_CONT1'],
      NUTR_CONT2: json['NUTR_CONT2'].isEmpty ? "미확인" : json['NUTR_CONT2'],
      NUTR_CONT3: json['NUTR_CONT3'].isEmpty ? "미확인" : json['NUTR_CONT3'],
      NUTR_CONT4: json['NUTR_CONT4'].isEmpty ? "미확인" : json['NUTR_CONT4'],
      NUTR_CONT5: json['NUTR_CONT5'].isEmpty ? "미확인" : json['NUTR_CONT5'],
      NUTR_CONT6: json['NUTR_CONT6'].isEmpty ? "미확인" : json['NUTR_CONT6'],
      NUTR_CONT7: json['NUTR_CONT7'].isEmpty ? "미확인" : json['NUTR_CONT7'],
      NUTR_CONT8: json['NUTR_CONT8'].isEmpty ? "미확인" : json['NUTR_CONT8'],
      NUTR_CONT9: json['NUTR_CONT9'].isEmpty ? "미확인" : json['NUTR_CONT9'],
    );
  }
}
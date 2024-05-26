# 현대인들의 건강관리 필수 품 보디가드 README

# ![body_logo_icon](https://github.com/suhunPark38/bodyguard/assets/118532970/4c324c8f-2e7c-4195-8cb7-cb5f1e54e182)

- Test NAME : 관리자
- Test ID :  admin@hs.com
- Test PW : 123456

## 목차
1. [프로젝트 목적](#프로젝트-목적)
2. [프로젝트 배경](#프로젝트-배경)
3. [프로젝트 목표](#프로젝트-목표)
4. [시연 모습](#시연-모습)
    1. [시작화면](#시작화면)
    2. [회원가입](#회원가입)
    3. [로그인](#로그인)
    4. [로그아웃](#로그아웃)
    5. [홈](#홈)
    6. [관리(식단)](#관리식단)
    7. [관리(활동)](#관리활동)
    8. [쇼핑](#쇼핑)
    9. [검색](#검색)
5. [사용 언어 및 기술](#사용-언어-및-기술)
6. [기대 효과](#기대-효과)

## 프로젝트 목적

### 프로젝트 정의
'보디가드' 어플리케이션은 사용자가 섭취한 음식의 영양정보와 칼로리를 체계적으로 기록하고 관리할 수 있도록 돕는 것을 목표로 합니다. 이를 통해 사용자는 권장 섭취량과 비교하여 식습관을 확인하고 개선할 수 있으며, 필요 시 관련 정보를 바탕으로 적절한 식단을 배달 및 주문할 수 있습니다.

### 프로젝트 배경
현대 사회에서 건강한 생활 습관의 중요성이 강조되면서 개인의 영양 관리에 대한 관심이 지속적으로 증가하고 있습니다. 특히 코로나19 이후 식음료 배달 앱의 사용량이 크게 증가하며 건강 관리에 대한 수요도 2020년 214조 원에서 2021년 253조 원으로 18% 증가했습니다. 이러한 배경 속에서 섭취한 음식의 칼로리를 계산하고 추적하는 일은 상당한 시간과 노력을 요구합니다. 이러한 문제를 해결하기 위해 사용자가 일상 생활에서 손쉽게 칼로리를 계산하고 관리할 수 있는 '보디가드' 어플리케이션 프로젝트를 진행하게 되었습니다. 이 서비스는 식음료 배달 앱의 이용 증가와 건강 관리에 대한 높아진 수요를 동시에 만족시키는 것을 목표로 합니다.

### 프로젝트 목표
프로젝트의 목표는 사용자가 간편하게 음식의 영양소 및 칼로리 정보를 확인하고, 개개인에 맞는 영양섭취를 균형 있게 하여 건강한 삶을 살 수 있도록 돕는 것입니다.

## 시연 모습

### 시작화면
- 접속 시 스플래시 화면이 잠시 나온 뒤 다음 페이지가 나타납니다.
- 로그인이 되어 있지 않은 경우: 로그인 페이지
- 로그인이 되어 있는 경우: 홈 화면

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/e3f0600d-4710-4745-8561-eba86d937d57" width="30%" height="30%">

### 회원가입

- 회원가입 시 자신의 정보와 이메일, 비밀번호를 입력받습니다.
- 주소 입력창을 누를 경우 주소 검색창이 나옵니다.
- 이메일 주소와 비밀번호를 입력 후 회원가입을 진행 시 이메일 형식과 비밀번호가 6자리가 아닐 경우 경고 문구가 나오고, 이미 가입된 이메일일 경우에도 하단에 경고 문구가 나타납니다.

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/0dfe3a90-fab7-4bb7-8cf0-12e599ae4ccd" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/81aee22d-1030-43f1-b7e0-18870766dd2b" width="30%" height="30%">

### 로그인
- 이메일 주소와 비밀번호를 입력하면 유효성 검사가 진행되고 통과하지 못한 경우 각 경고 문구가 입력창 하단에 표시됩니다.
- 이메일 주소의 형식이 유효하지 않거나 비밀번호가 6자 미만일 경우와 로그인 정보가 없을 경우 하단에 경고 문구가 나타납니다.
- 로그인에 성공하면 홈 화면으로 이동합니다.

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/7b34c091-818e-4d52-a38b-516b7dbff9f5" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/f9d3418b-e815-4de7-b97a-4012d7f44c68" width="30%" height="30%">

### 로그아웃
내 정보창에서 로그아웃을 누르면 로그아웃이 진행됩니다.

### 홈
- 홈 화면에서는 상단에 검색, 쇼핑, 알림 아이콘이 있습니다.
  하단에는 홈, 검색, 관리, 쇼핑, 내 정보 내비게이션 바가 있습니다.
- 메인 부분에는 주문하기 버튼과 각종 상태 정보를 볼 수 있으며, 버튼을 누르면 해당 화면으로 이동합니다.
- 하단 캐러셀은 랜덤으로 가게의 메뉴를 추천하며, 그 메뉴에 대한 정보를 보여줍니다.
- 또한 원하는 메뉴가 나왔을 때 누르면, 즉시 구매 페이지로 이동합니다.

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/7cd8faf3-c49b-48b1-ae61-d0bfce82eee8" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/c72ce6d8-aba2-4f45-a5f7-323735af7cca" width="30%" height="30%">

### 관리(식단)
- 칼로리 확인하기 버튼이나 하단의 로고 아이콘을 누르면 관리 화면(식단 부분)이 나옵니다.
- 이곳에서는 내가 섭취한 음식을 입력할 수 있습니다.
- 날짜별로 섭취한 음식을 입력할 수 있어 과거의 기록도 조회가 가능합니다.
- 또한 입력된 음식의 칼로리 및 권장섭취량은 물론, 탄단지의 섭취 비율도 확인 가능합니다.

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/31522a15-752c-4493-91de-70f586862516" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/ff10b932-3b70-459c-a812-807f21cfb050" width="30%" height="30%">

### 관리(활동)
- 홈에서 걷기 버튼을 누르거나 관리 화면에서 활동으로 넘어가면 나옵니다.
- 이곳에서는 나의 활동에 필요한 정보들이 모여 있습니다.
- 이 화면 역시 과거의 기록을 조회할 수 있습니다.

### 쇼핑
- 쇼핑 아이콘을 통해 넘어갈 수 있습니다.
- 이곳에서는 배달 음식을 주문할 수 있습니다.
- 포장을 원하는 고객을 위해 가게의 위치를 알 수 있는 지도 기능도 지원합니다.
- 결제하기 버튼을 누르면 결제 알림이 나옵니다.
- 원하는 음식을 주문한 경우 성공 알림이 나옵니다.
- 결제 내역을 통해 확인이 가능하며, 과거의 결제 내역도 확인할 수 있습니다.

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/c050cbcf-4d4a-404e-82c0-9c956658f932" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/ad028d4a-9fcb-4d45-a8a6-0165f75d1dda" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/6204ea3c-93be-4078-945a-ac0e3b39291c" width="30%" height="30%">

### 검색
- 검색 아이콘을 통해 배달 음식을 주문할 수 있습니다.
- 음식을 검색하거나 가게 이름을 검색할 수 있습니다.
- 최근 검색어 및 인기 검색어 기능이 있습니다.
- 카테고리를 통해 해당 주문 페이지로 이동할 수 있습니다.

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/b531b09f-12a8-4246-9b8c-5ad9b5c453b7" width="30%" height="30%"> <img src="https://github.com/suhunPark38/bodyguard/assets/118532970/ee513c43-584d-49b5-bfb4-4d03b521bef2" width="30%" height="30%">

## 사용 언어 및 기술

<img src="https://github.com/suhunPark38/bodyguard/assets/118532970/571d26f6-2f4d-49f3-94f0-f16aa48b62cd" width="50%" height="50%">

### 주요 적용 기술 및 구조





- **개발 환경**: <img src="https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white" height="30%">

- **개발 도구**: <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" height="30%">

- **개발 언어**: <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" height="30%">

- **관련 기술**: <img src="https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white" width="15%" height="15%"><img src="https://github.com/suhunPark38/bodyguard/assets/118532970/ef56b6fa-8c6f-4dff-aed3-da477626d62d" width="5%" height="5%">(**Health Connect**)

  

## 기대 효과
- 식단 관리에 익숙하지 않은 사람도 음식을 더 의식적으로 선택하도록 유도하여 건강한 식습관을 유지하고 발전할 수 있도록 돕습니다.
- 사용자가 섭취한 칼로리를 추적함으로써 식이 습관을 분석하고 조절할 수 있습니다. 이를 통해 체중을 관리하거나 다이어트 목표를 달성하는 데 도움을 줄 수 있습니다.
- 이 앱을 사용하여 섭취한 음식의 영양 정보를 기록하면 영양 균형을 유지하고 필요한 영양소를 충족시키는 데 도움이 됩니다.


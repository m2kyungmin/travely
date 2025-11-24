# 트래블리 (Travely) - 나만의 여행 성향 찾기

16개 문항으로 사용자의 여행 성향을 분석하여 4가지 축 기반 16가지 여행 유형 중 하나로 분류하고, 맞춤 여행지를 추천하는 심리테스트형 서비스입니다.

## 주요 기능

- ✅ 16개 문항 기반 여행 MBTI 테스트
- ✅ 4가지 축 (리듬, 에너지, 예산, 컨셉) 기반 16가지 유형 분류
- ✅ 맞춤 여행지 추천
- ✅ 결과 공유 기능 (카카오톡, 인스타그램 등)
- ✅ 이전 결과 저장 및 조회
- ✅ Google AdMob 광고 연동
- ✅ Firebase Firestore 데이터베이스 연동

## 기술 스택

- **Frontend**: Flutter (iOS/Android/Web 동시 지원)
- **Backend**: Firebase (Firestore, Authentication, Analytics)
- **광고**: Google AdMob
- **로컬 저장**: SharedPreferences

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   ├── question.dart         # 질문 모델
│   ├── travel_type.dart      # 여행 유형 모델
│   └── test_result.dart      # 테스트 결과 모델
├── screens/                  # 화면
│   ├── splash_screen.dart    # 스플래시 화면
│   ├── home_screen.dart      # 홈 화면
│   ├── test_screen.dart      # 테스트 화면
│   ├── loading_screen.dart   # 로딩 화면
│   └── result_screen.dart    # 결과 화면
├── services/                 # 서비스 클래스
│   ├── firestore_service.dart # Firestore 연동
│   ├── storage_service.dart   # 로컬 저장
│   ├── ad_service.dart        # AdMob 광고
│   └── test_service.dart      # 테스트 로직
└── utils/                    # 유틸리티
    └── test_calculator.dart   # 테스트 점수 계산
```

## 설치 및 실행

### 1. 패키지 설치

```bash
flutter pub get
```

### 2. Firebase 설정

1. Firebase Console에서 새 프로젝트 생성
2. iOS/Android 앱 등록
3. `google-services.json` (Android) 및 `GoogleService-Info.plist` (iOS) 파일 다운로드
4. 각 플랫폼 폴더에 파일 배치

### 3. Firestore 데이터베이스 설정

Firestore에 다음 컬렉션을 생성하고 데이터를 추가하세요:

#### questions 컬렉션

```json
{
  "id": "q1",
  "order": 1,
  "text": "여행 계획은…",
  "optionA": "대략적인 방향만 정하고 떠난다.",
  "optionB": "시간대별 구체적인 일정표가 있어야 편하다.",
  "axis": "rhythm",
  "scoreA": "S",
  "scoreB": "P"
}
```

#### types 컬렉션

```json
{
  "code": "SABN",
  "name": "자유로운 탐험가",
  "description": "즉흥적이고 활동적인 당신은...",
  "imageUrl": "https://...",
  "traits": {
    "rhythm": "계획 없이 떠나도 OK",
    "energy": "하루 2만보는 기본",
    "budget": "가성비 최고 추구",
    "concept": "자연 속에서 힐링"
  },
  "destinations": [
    {
      "name": "베트남 다낭",
      "description": "저렴하게 즐기는 해변과 자연",
      "affiliateLink": "https://..."
    }
  ]
}
```

### 4. AdMob 설정

1. Google AdMob 계정 생성
2. 앱 등록 및 광고 단위 생성
3. `lib/services/ad_service.dart`에서 테스트 광고 ID를 실제 ID로 교체

### 5. 앱 실행

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## 개발 상태

현재 MVP 버전이 완성되었습니다. 다음 단계로 진행할 작업:

- [ ] Firebase 실제 데이터 입력
- [ ] AdMob 실제 광고 단위 ID 설정
- [ ] 유형별 캐릭터 이미지 추가
- [ ] 공유 이미지 생성 기능
- [ ] 앱스토어/플레이스토어 출시 준비

## 라이선스

이 프로젝트는 개인 프로젝트입니다.

# Firebase 설정 가이드

## 1. Firebase 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com/)에 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름 입력 (예: travely)
4. Google Analytics 설정 (선택사항)

## 2. Android 앱 등록

1. Firebase Console에서 "Android 앱 추가" 클릭
2. 패키지 이름 입력: `com.example.travely` (실제 패키지명으로 변경 필요)
3. `google-services.json` 파일 다운로드
4. `android/app/` 폴더에 `google-services.json` 파일 복사

### android/app/build.gradle.kts 수정

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // 추가
}

dependencies {
    // Firebase 추가
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics")
}
```

### android/build.gradle.kts 수정

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0") // 추가
    }
}
```

## 3. iOS 앱 등록

1. Firebase Console에서 "iOS 앱 추가" 클릭
2. 번들 ID 입력: `com.example.travely` (실제 번들 ID로 변경 필요)
3. `GoogleService-Info.plist` 파일 다운로드
4. Xcode에서 `ios/Runner/` 폴더에 파일 추가

## 4. Firestore 데이터베이스 설정

1. Firebase Console에서 "Firestore Database" 선택
2. "데이터베이스 만들기" 클릭
3. 테스트 모드로 시작 (나중에 보안 규칙 설정 필요)

### 컬렉션 생성

#### questions 컬렉션

각 문서 ID는 `q1`, `q2`, ... `q16` 형식으로 생성:

```json
{
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

각 문서 ID는 유형 코드 (예: `SABN`, `SABC`, ...):

```json
{
  "code": "SABN",
  "name": "자유로운 탐험가",
  "description": "즉흥적이고 활동적인 당신은 배낭 하나로 자연을 누비는 모험가입니다.",
  "imageUrl": "",
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
      "affiliateLink": ""
    }
  ]
}
```

#### results 컬렉션 (자동 생성)

통계용 컬렉션으로, 앱에서 자동으로 생성됩니다.

## 5. 보안 규칙 설정

Firestore 보안 규칙 예시:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // questions는 읽기만 허용
    match /questions/{questionId} {
      allow read: if true;
      allow write: if false;
    }
    
    // types는 읽기만 허용
    match /types/{typeId} {
      allow read: if true;
      allow write: if false;
    }
    
    // results는 읽기/쓰기 모두 허용 (통계용)
    match /results/{resultId} {
      allow read, write: if true;
    }
  }
}
```

## 6. Firebase Analytics 설정

`lib/main.dart`에서 이미 초기화되어 있습니다. 추가 설정이 필요하면 Firebase Console에서 확인하세요.

## 참고사항

- 테스트 환경에서는 Firestore 보안 규칙을 완화할 수 있지만, 프로덕션에서는 반드시 적절한 규칙을 설정하세요.
- 실제 앱 출시 전에 모든 데이터를 입력하고 테스트하세요.


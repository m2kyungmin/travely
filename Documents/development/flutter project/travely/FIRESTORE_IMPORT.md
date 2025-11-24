# Firestore 데이터 가져오기 가이드

## 1. JSON 파일 구조

`firestore_data.json` 파일에는 다음 두 개의 컬렉션 데이터가 포함되어 있습니다:
- `questions`: 16개 질문 데이터
- `types`: 16개 여행 유형 데이터

## 2. Firestore에 데이터 가져오기 방법

### 방법 1: Firebase Console에서 수동 입력

1. Firebase Console 접속
2. Firestore Database 선택
3. 각 컬렉션 생성 및 문서 추가

#### questions 컬렉션
- 컬렉션 이름: `questions`
- 각 문서 ID: `q1`, `q2`, ... `q16`
- 필드:
  - `order` (number)
  - `text` (string)
  - `optionA` (string)
  - `optionB` (string)
  - `axis` (string)
  - `scoreA` (string)
  - `scoreB` (string)

#### types 컬렉션
- 컬렉션 이름: `types`
- 각 문서 ID: 유형 코드 (예: `SABN`, `PRLC`, ...)
- 필드:
  - `code` (string)
  - `name` (string)
  - `description` (string)
  - `imageUrl` (string)
  - `traits` (map)
    - `rhythm` (string)
    - `energy` (string)
    - `budget` (string)
    - `concept` (string)
  - `destinations` (array)
    - 각 항목:
      - `name` (string)
      - `description` (string)
      - `imageUrl` (string)
      - `affiliateLink` (string)

### 방법 2: Firebase CLI 사용 (권장)

```bash
# Firebase CLI 설치 (없는 경우)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 초기화 (이미 초기화된 경우 생략)
firebase init firestore

# JSON 파일을 Firestore로 가져오기
# 주의: 이 방법은 기존 데이터를 덮어쓸 수 있습니다
```

### 방법 3: Node.js 스크립트 사용

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./path/to/serviceAccountKey.json');
const data = require('./firestore_data.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Questions 가져오기
async function importQuestions() {
  const questions = data.questions;
  for (const question of questions) {
    await db.collection('questions').doc(question.id).set({
      order: question.order,
      text: question.text,
      optionA: question.optionA,
      optionB: question.optionB,
      axis: question.axis,
      scoreA: question.scoreA,
      scoreB: question.scoreB
    });
  }
  console.log('Questions imported successfully');
}

// Types 가져오기
async function importTypes() {
  const types = data.types;
  for (const type of types) {
    await db.collection('types').doc(type.code).set({
      code: type.code,
      name: type.name,
      description: type.description,
      imageUrl: type.imageUrl,
      traits: type.traits,
      destinations: type.destinations
    });
  }
  console.log('Types imported successfully');
}

// 실행
async function importAll() {
  await importQuestions();
  await importTypes();
  process.exit(0);
}

importAll();
```

## 3. 주의사항

1. **이미지 URL**: `imageUrl` 필드는 예시 URL입니다. 실제 이미지를 업로드한 후 URL로 교체하세요.

2. **제휴 링크**: `affiliateLink` 필드는 예시 링크입니다. 실제 제휴 링크로 교체하세요.

3. **데이터 검증**: 가져오기 전에 JSON 파일의 데이터가 올바른지 확인하세요.

4. **백업**: 기존 데이터가 있다면 가져오기 전에 백업하세요.

## 4. 데이터 구조 확인

가져오기 후 Firebase Console에서 다음을 확인하세요:
- 각 컬렉션에 올바른 개수의 문서가 있는지
- 필드 타입이 올바른지
- 필수 필드가 모두 채워져 있는지


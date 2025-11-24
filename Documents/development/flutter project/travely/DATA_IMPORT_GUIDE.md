# Firestore 데이터 입력 가이드

## ✅ 데이터베이스 생성 완료!

이제 데이터를 입력하세요.

## 방법 1: 자동화 스크립트 사용 (빠름) ⚡

### Step 1: 서비스 계정 키 다운로드

1. [Firebase Console - 서비스 계정](https://console.firebase.google.com/project/travely-mbti/settings/serviceaccounts/adminsdk) 접속
2. **"새 비공개 키 생성"** 클릭
3. JSON 파일 다운로드
4. 프로젝트 루트에 `serviceAccountKey.json`으로 저장

### Step 2: 패키지 설치

```bash
cd "/Users/leekyungmin/Documents/development/flutter project/travely"
npm install firebase-admin
```

### Step 3: 데이터 입력

```bash
# 전체 데이터 입력
node scripts/import_firestore.js

# 또는 questions만 입력
node scripts/import_questions_only.js

# 또는 types만 입력
node scripts/import_types_only.js
```

## 방법 2: Firebase Console에서 수동 입력

### questions 컬렉션 (16개)

1. [Firestore Console](https://console.firebase.google.com/project/travely-mbti/firestore) 접속
2. **"컬렉션 시작"** 클릭
3. 컬렉션 ID: `questions`
4. 문서 ID: `q1` 입력
5. 필드 추가:

| 필드 | 타입 | 값 |
|------|------|-----|
| order | number | 1 |
| text | string | 여행 계획은… |
| optionA | string | 대략적인 방향만 정하고 떠난다. |
| optionB | string | 시간대별 구체적인 일정표가 있어야 편하다. |
| axis | string | rhythm |
| scoreA | string | S |
| scoreB | string | P |

6. **"저장"** 클릭
7. `q2`부터 `q16`까지 반복

**전체 질문 데이터**: `firestore_data.json` 파일의 `questions` 배열 참고

### types 컬렉션 (16개)

1. **"컬렉션 시작"** 클릭
2. 컬렉션 ID: `types`
3. 문서 ID: `SABN` 입력
4. 필드 추가:

**기본 필드:**
- `code` (string): SABN
- `name` (string): 자유로운 탐험가
- `description` (string): 즉흥적이고 활동적인 당신은 배낭 하나로 자연을 누비는 모험가입니다...
- `imageUrl` (string): https://example.com/images/sabn.png

**traits (map):**
- `rhythm` (string): 계획 없이 떠나도 OK!...
- `energy` (string): 하루 2만보는 기본!...
- `budget` (string): 가성비 최고 추구!...
- `concept` (string): 자연 속에서 힐링!...

**destinations (array):**
- 항목 1 (map):
  - `name` (string): 베트남 다낭
  - `description` (string): 저렴하게 즐기는 해변과 자연...
  - `imageUrl` (string): https://example.com/images/da-nang.jpg
  - `affiliateLink` (string): https://www.agoda.com/search?city=12345
- 항목 2, 3도 동일하게 추가

5. **"저장"** 클릭
6. 나머지 15개 유형 반복

**전체 유형 데이터**: `firestore_data.json` 파일의 `types` 객체 참고

## 📋 체크리스트

입력 완료 후 확인:

- [ ] questions 컬렉션: 16개 문서 (q1 ~ q16)
- [ ] types 컬렉션: 16개 문서 (SABN, SABC, ..., PRLC)
- [ ] 각 질문에 7개 필드 모두 입력
- [ ] 각 유형에 모든 필드 입력 (code, name, description, imageUrl, traits, destinations)

## 🚀 빠른 시작

**가장 빠른 방법**: 서비스 계정 키 다운로드 → 자동화 스크립트 실행

```bash
# 1. 서비스 계정 키 다운로드 후 프로젝트 루트에 저장
# 2. 패키지 설치
npm install firebase-admin

# 3. 데이터 입력
node scripts/import_firestore.js
```

## ✅ 완료 후

데이터 입력이 완료되면:

1. 앱 테스트:
   ```bash
   flutter run
   ```

2. 웹에서 테스트:
   ```bash
   flutter run -d chrome
   ```

3. 배포된 웹사이트 확인:
   - https://travely-mbti.web.app


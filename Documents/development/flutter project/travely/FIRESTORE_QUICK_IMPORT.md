# Firestore 데이터 빠른 입력 가이드

## 🚀 가장 빠른 방법: Firebase Console에서 직접 입력

### Step 1: Firestore Database 활성화

1. [Firebase Console](https://console.firebase.google.com/project/travely-mbti) 접속
2. 왼쪽 메뉴에서 **"Firestore Database"** 클릭
3. **"데이터베이스 만들기"** 클릭
4. **"테스트 모드로 시작"** 선택 (나중에 보안 규칙 설정)
5. 위치 선택 (asia-northeast3 - 서울 권장)

### Step 2: questions 컬렉션 생성

1. **"컬렉션 시작"** 클릭
2. 컬렉션 ID: `questions` 입력
3. 문서 ID: `q1` 입력
4. 필드 추가 (각 필드마다 "필드 추가" 클릭):

```
필드 이름: order
타입: number
값: 1

필드 이름: text
타입: string
값: 여행 계획은…

필드 이름: optionA
타입: string
값: 대략적인 방향만 정하고 떠난다.

필드 이름: optionB
타입: string
값: 시간대별 구체적인 일정표가 있어야 편하다.

필드 이름: axis
타입: string
값: rhythm

필드 이름: scoreA
타입: string
값: S

필드 이름: scoreB
타입: string
값: P
```

5. **"저장"** 클릭
6. `q2`부터 `q16`까지 동일하게 반복 (firestore_data.json 참고)

### Step 3: types 컬렉션 생성

1. **"컬렉션 시작"** 클릭
2. 컬렉션 ID: `types` 입력
3. 문서 ID: `SABN` 입력 (첫 번째 유형)
4. 필드 추가:

```
필드 이름: code
타입: string
값: SABN

필드 이름: name
타입: string
값: 자유로운 탐험가

필드 이름: description
타입: string
값: 즉흥적이고 활동적인 당신은 배낭 하나로 자연을 누비는 모험가입니다. 계획에 얽매이지 않고 순간의 영감을 따라 떠나는 자유로운 영혼이에요. 가성비를 중시하며 자연 속에서 진정한 힐링을 찾는 타입입니다. 예상치 못한 상황도 즐거운 경험으로 바꾸는 당신의 여행은 언제나 특별한 추억이 됩니다.

필드 이름: imageUrl
타입: string
값: https://example.com/images/sabn.png

필드 이름: traits
타입: map
  - rhythm (string): 계획 없이 떠나도 OK! 즉흥적인 여행을 즐기는 자유로운 영혼
  - energy (string): 하루 2만보는 기본! 활동적인 액티비티로 하루를 가득 채우는 에너지 뿜뿜
  - budget (string): 가성비 최고 추구! 현명한 소비로 더 많은 경험을 즐기는 스마트 여행자
  - concept (string): 자연 속에서 힐링! 도시의 소음보다 숲과 바다의 평화를 선호

필드 이름: destinations
타입: array
  - 항목 1 (map):
    - name (string): 베트남 다낭
    - description (string): 저렴하게 즐기는 해변과 자연, 즉흥적인 여행에 최적
    - imageUrl (string): https://example.com/images/da-nang.jpg
    - affiliateLink (string): https://www.agoda.com/search?city=12345
  - 항목 2, 3도 동일하게 추가
```

5. **"저장"** 클릭
6. 나머지 15개 유형도 동일하게 반복

## 📋 체크리스트

입력 완료 후 확인:

- [ ] questions 컬렉션에 16개 문서 (q1 ~ q16)
- [ ] types 컬렉션에 16개 문서 (SABN, SABC, ..., PRLC)
- [ ] 각 질문에 7개 필드 모두 입력됨
- [ ] 각 유형에 code, name, description, imageUrl, traits, destinations 입력됨
- [ ] traits는 4개 필드 (rhythm, energy, budget, concept)
- [ ] destinations는 각 유형마다 3개 항목

## ⚡ 빠른 팁

### 대량 입력 팁

1. **첫 번째 문서를 완벽하게 만들기**
   - 모든 필드와 구조를 정확히 입력
   - 이후 문서는 "복사" 기능 사용 가능

2. **JSON 직접 붙여넣기** (고급)
   - Firebase Console의 일부 기능으로 JSON import 가능
   - 또는 스크립트 사용 (아래 참고)

## 🔧 자동화 스크립트 사용 (선택)

더 빠르게 입력하려면 스크립트를 사용하세요:

### Node.js 스크립트

1. 서비스 계정 키 다운로드:
   - Firebase Console → 프로젝트 설정 → 서비스 계정
   - "새 비공개 키 생성" → `serviceAccountKey.json` 저장

2. 패키지 설치:
   ```bash
   npm install firebase-admin
   ```

3. 스크립트 실행:
   ```bash
   node scripts/import_firestore.js
   ```

## 🔒 보안 규칙 설정 (중요!)

데이터 입력 후 보안 규칙을 설정하세요:

Firebase Console → Firestore Database → 규칙

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

## ✅ 완료 확인

데이터 입력이 완료되면:

1. 앱 실행: `flutter run`
2. 테스트 시작 버튼 클릭
3. 질문이 정상적으로 표시되는지 확인
4. 테스트 완료 후 결과가 정상적으로 표시되는지 확인


# Firestore 데이터 Import 가이드

## 1. questions 컬렉션 Import

### 방법 1: Firebase Console에서 수동 입력

1. Firebase Console → Firestore Database 접속
2. `questions` 컬렉션 생성
3. 각 질문을 문서로 추가 (문서 ID: q1, q2, ..., q16)
4. 아래 JSON 데이터를 복사하여 각 필드에 입력

### 방법 2: Firebase CLI 사용

```bash
# Firebase CLI 설치 (이미 설치되어 있다면 생략)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 초기화 (이미 되어 있다면 생략)
firebase init firestore

# questions.json 파일 생성 후 아래 명령어 실행
firebase firestore:import questions.json
```

### questions 컬렉션 데이터 구조

각 문서는 다음과 같은 구조를 가집니다:

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

**문서 ID**: q1, q2, q3, ..., q16 (순서대로)

---

## 2. types 컬렉션 Import

### 방법 1: Firebase Console에서 수동 입력

1. Firebase Console → Firestore Database 접속
2. `types` 컬렉션 생성
3. 각 유형을 문서로 추가 (문서 ID: SABN, SABC, ..., PRLC)
4. 아래 JSON 데이터를 복사하여 각 필드에 입력

### 방법 2: Firebase CLI 사용

```bash
# types.json 파일 생성 후 아래 명령어 실행
firebase firestore:import types.json
```

### types 컬렉션 데이터 구조

각 문서는 다음과 같은 구조를 가집니다:

```json
{
  "code": "SABN",
  "name": "자유로운 탐험가",
  "description": "즉흥적이고 활동적인 당신은...",
  "imageUrl": "https://example.com/images/sabn.png",
  "traits": {
    "rhythm": "계획 없이 떠나도 OK! 즉흥적인 여행을 즐기는 자유로운 영혼",
    "energy": "하루 2만보는 기본! 활동적인 액티비티로 하루를 가득 채우는 에너지 뿜뿜",
    "budget": "가성비 최고 추구! 현명한 소비로 더 많은 경험을 즐기는 스마트 여행자",
    "concept": "자연 속에서 힐링! 도시의 소음보다 숲과 바다의 평화를 선호"
  },
  "destinations": [
    {
      "name": "베트남 다낭",
      "description": "저렴하게 즐기는 해변과 자연, 즉흥적인 여행에 최적",
      "imageUrl": "https://example.com/images/da-nang.jpg",
      "affiliateLink": "https://www.agoda.com/search?city=12345"
    }
  ]
}
```

**문서 ID**: SABN, SABC, SALN, SALC, SRBN, SRBC, SRLN, SRLC, PABN, PABC, PALN, PALC, PRBN, PRBC, PRLN, PRLC

---

## 3. 데이터 Import 순서

1. **questions 컬렉션 먼저 생성** (앱이 정상 작동하려면 필수)
2. **types 컬렉션 생성** (결과 화면에서 사용)

---

## 4. 주의사항

- **imageUrl**: 실제 이미지 URL로 교체 필요
- **affiliateLink**: 실제 제휴 링크로 교체 필요
- **Placeholder 데이터**: SABN, PRLC, PABC, SRLN 외 12개 유형은 placeholder로 작성되어 있음. 실제 콘텐츠로 교체 필요
- **문서 ID**: 반드시 지정된 ID 사용 (q1~q16, 유형 코드)

---

## 5. 빠른 Import 스크립트 (선택적)

Firebase Console에서 직접 복사-붙여넣기하는 것이 가장 간단합니다.

1. `firestore_data.json` 파일 열기
2. `questions` 배열의 각 항목을 복사
3. Firebase Console에서 해당 문서 생성 후 필드에 붙여넣기
4. `types` 객체의 각 항목도 동일하게 반복

---

## 6. 데이터 검증

Import 후 다음을 확인하세요:

- [ ] questions 컬렉션에 16개 문서가 있는지 확인
- [ ] 각 질문의 order가 1~16인지 확인
- [ ] types 컬렉션에 16개 문서가 있는지 확인
- [ ] 각 유형의 code가 문서 ID와 일치하는지 확인
- [ ] 각 유형에 destinations 배열이 3개씩 있는지 확인


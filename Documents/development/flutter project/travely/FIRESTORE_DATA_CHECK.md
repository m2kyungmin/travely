# Firestore 데이터 확인 및 수정 가이드

## 🔍 문제 진단

일부 유형은 정상 표시되고, 일부는 "Placeholder" 텍스트가 표시되는 경우:

### 원인
1. Firestore의 `types` 컬렉션에 일부 유형만 데이터가 입력됨
2. 일부 필드가 비어있거나 "Placeholder" 텍스트로 저장됨
3. 필드 이름이 일치하지 않음

## ✅ 해결 방법

### 1. Firestore Console에서 데이터 확인

[Firebase Console - Firestore](https://console.firebase.google.com/project/travely-mbti/firestore)에서:

1. **types** 컬렉션 클릭
2. 각 문서 확인 (총 16개 필요):
   - SABN, SABC, SALN, SALC
   - SRBN, SRBC, SRLN, SRLC
   - PABN, PABC, PALN, PALC
   - PRBN, PRBC, PRLN, PRLC

### 2. 각 문서의 필드 확인

각 문서에 다음 필드가 모두 있어야 합니다:

#### 필수 필드:
- `code` (string): 유형 코드 (예: "SABN")
- `name` (string): 유형 이름 (예: "자유로운 탐험가")
- `description` (string): 상세 설명
- `imageUrl` (string): 이미지 URL
- `traits` (map): 성향 정보
  - `rhythm` (string): 여행 리듬 설명
  - `energy` (string): 여행 에너지 설명
  - `budget` (string): 여행 예산 설명
  - `concept` (string): 여행 컨셉 설명
- `destinations` (array): 추천 여행지 목록

### 3. 문제가 있는 문서 수정

예: **SRBN** 유형이 placeholder로 표시되는 경우:

1. Firestore Console에서 `SRBN` 문서 열기
2. 다음 필드 확인 및 수정:

```json
{
  "code": "SRBN",
  "name": "유형 이름 (Placeholder 아님)",
  "description": "상세 설명 (Placeholder 아님)",
  "imageUrl": "https://example.com/images/srbn.png",
  "traits": {
    "rhythm": "여행 리듬 설명 (Placeholder 아님)",
    "energy": "여행 에너지 설명 (Placeholder 아님)",
    "budget": "여행 예산 설명 (Placeholder 아님)",
    "concept": "여행 컨셉 설명 (Placeholder 아님)"
  },
  "destinations": []
}
```

### 4. 빠른 수정 방법

#### 방법 1: Firebase Console에서 직접 수정
1. Firestore Console 접속
2. `types` 컬렉션 → 문제 있는 문서 선택
3. 필드 편집
4. "Placeholder" 텍스트를 실제 내용으로 교체

#### 방법 2: 데이터 재입력
1. `firestore_data.json` 파일 확인
2. 누락된 유형 데이터 확인
3. Firebase Console에서 수동 입력 또는 스크립트 재실행

## 🔧 디버깅

### 브라우저 콘솔 확인

1. 웹사이트 접속: https://travely-mbti.web.app
2. **F12** → **Console** 탭
3. 테스트 진행
4. 다음 로그 확인:
   - `유형 [코드]를 Firestore에서 가져왔습니다.`
   - `⚠️ 유형 [코드]의 name이 비어있거나 placeholder입니다.`
   - `⚠️ 유형 [코드]의 traits가 비어있습니다.`

### 문제가 있는 유형 확인

브라우저 콘솔에서 다음 로그를 찾으세요:
- `⚠️` 표시가 있는 유형 코드
- 해당 유형의 Firestore 문서 확인

## 📝 체크리스트

각 유형 문서에 대해 확인:

- [ ] `code` 필드가 올바른 유형 코드인가?
- [ ] `name` 필드가 비어있지 않고 "Placeholder"가 아닌가?
- [ ] `description` 필드가 비어있지 않고 "Placeholder"가 아닌가?
- [ ] `traits` 맵에 4개 키가 모두 있는가? (rhythm, energy, budget, concept)
- [ ] 각 `traits` 값이 비어있지 않고 "Placeholder"가 아닌가?
- [ ] `destinations` 배열이 존재하는가? (비어있어도 됨)

## 🚀 다음 단계

1. Firestore Console에서 모든 유형 확인
2. 문제가 있는 유형 수정
3. 웹사이트에서 다시 테스트
4. 브라우저 콘솔에서 로그 확인

## 💡 참고

- 현재 앱은 placeholder 텍스트를 감지하여 "데이터를 불러오는 중입니다..."로 표시합니다.
- 하지만 근본적인 해결책은 Firestore에 올바른 데이터를 입력하는 것입니다.


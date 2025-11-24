# Firestore 데이터베이스 생성 및 데이터 입력

## Step 1: Firestore 데이터베이스 생성

1. [Firebase Console - Firestore](https://console.firebase.google.com/project/travely-mbti/firestore) 접속
2. **"데이터베이스 만들기"** 버튼 클릭
3. 설정 선택:
   - **모드**: "테스트 모드로 시작" 선택
   - **위치**: `asia-northeast3` (서울) 선택
4. **"사용 설정"** 클릭
5. 몇 초 대기 (데이터베이스 생성 중)

## Step 2: 데이터 입력 (Firebase Console)

### questions 컬렉션 입력

1. Firestore Database 화면에서 **"컬렉션 시작"** 클릭
2. 컬렉션 ID: `questions` 입력
3. 첫 번째 문서 생성:
   - 문서 ID: `q1` 입력
   - 필드 추가 버튼 클릭하여 다음 필드들 추가:

| 필드 이름 | 타입   | 값                                        |
| --------- | ------ | ----------------------------------------- |
| order     | number | 1                                         |
| text      | string | 여행 계획은…                              |
| optionA   | string | 대략적인 방향만 정하고 떠난다.            |
| optionB   | string | 시간대별 구체적인 일정표가 있어야 편하다. |
| axis      | string | rhythm                                    |
| scoreA    | string | S                                         |
| scoreB    | string | P                                         |

4. **"저장"** 클릭
5. `q2`부터 `q16`까지 동일하게 반복

**빠른 팁**: 첫 번째 문서를 완벽하게 만든 후, 문서를 복사하여 수정하면 더 빠릅니다!

### types 컬렉션 입력

1. **"컬렉션 시작"** 클릭
2. 컬렉션 ID: `types` 입력
3. 첫 번째 문서 생성 (SABN):
   - 문서 ID: `SABN` 입력
   - 필드 추가:

#### 기본 필드

- `code` (string): SABN
- `name` (string): 자유로운 탐험가
- `description` (string): 즉흥적이고 활동적인 당신은 배낭 하나로 자연을 누비는 모험가입니다. 계획에 얽매이지 않고 순간의 영감을 따라 떠나는 자유로운 영혼이에요. 가성비를 중시하며 자연 속에서 진정한 힐링을 찾는 타입입니다. 예상치 못한 상황도 즐거운 경험으로 바꾸는 당신의 여행은 언제나 특별한 추억이 됩니다.
- `imageUrl` (string): https://example.com/images/sabn.png

#### traits 필드 (map 타입)

- 필드 이름: `traits`
- 타입: **map** 선택
- map 내부에 4개 필드 추가:
  - `rhythm` (string): 계획 없이 떠나도 OK! 즉흥적인 여행을 즐기는 자유로운 영혼
  - `energy` (string): 하루 2만보는 기본! 활동적인 액티비티로 하루를 가득 채우는 에너지 뿜뿜
  - `budget` (string): 가성비 최고 추구! 현명한 소비로 더 많은 경험을 즐기는 스마트 여행자
  - `concept` (string): 자연 속에서 힐링! 도시의 소음보다 숲과 바다의 평화를 선호

#### destinations 필드 (array 타입)

- 필드 이름: `destinations`
- 타입: **array** 선택
- 배열에 3개 항목 추가 (각 항목은 map):

  **항목 1:**

  - 타입: map
  - map 내부 필드:
    - `name` (string): 베트남 다낭
    - `description` (string): 저렴하게 즐기는 해변과 자연, 즉흥적인 여행에 최적
    - `imageUrl` (string): https://example.com/images/da-nang.jpg
    - `affiliateLink` (string): https://www.agoda.com/search?city=12345

  **항목 2, 3도 동일하게 추가**

4. **"저장"** 클릭
5. 나머지 15개 유형도 동일하게 반복

## 📋 전체 데이터 목록

### questions (16개)

- q1 ~ q16: `firestore_data.json`의 `questions` 배열 참고

### types (16개)

- SABN, SABC, SALN, SALC
- SRBN, SRBC, SRLN, SRLC
- PABN, PABC, PALN, PALC
- PRBN, PRBC, PRLN, PRLC

**상세 데이터**: `firestore_data.json` 파일의 `types` 객체 참고

## ⚡ 빠른 입력 팁

1. **첫 문서를 완벽하게 만들기** - 이후 복사하여 수정
2. **배치 입력** - 여러 문서를 한 번에 선택하여 복사 가능
3. **JSON import** - Firebase Console의 일부 기능으로 JSON 직접 붙여넣기 가능

## ✅ 완료 확인

입력 완료 후:

- questions 컬렉션: 16개 문서
- types 컬렉션: 16개 문서

각 문서의 필드가 모두 입력되었는지 확인하세요!

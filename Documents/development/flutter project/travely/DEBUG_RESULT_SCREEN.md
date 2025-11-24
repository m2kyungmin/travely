# 결과 화면 문제 디버깅 가이드

## 🔍 문제 진단

결과 화면이 빈 화면으로 표시되는 경우, 다음을 확인하세요:

### 1. 브라우저 콘솔 확인

1. 웹사이트 접속: https://travely-mbti.web.app
2. **F12** 또는 **우클릭 → 검사**로 개발자 도구 열기
3. **Console** 탭 클릭
4. 테스트를 다시 진행
5. 다음 로그 확인:
   - `결과 유형 코드: [코드]` - 계산된 유형 코드
   - `가져온 유형 정보: [코드 또는 null]` - Firestore에서 가져온 유형
   - `⚠️ 유형 정보를 가져오지 못했습니다.` - 에러 메시지

### 2. Firestore 데이터 확인

[Firebase Console - Firestore](https://console.firebase.google.com/project/travely-mbti/firestore)에서:

1. **types** 컬렉션 확인
2. 계산된 유형 코드와 동일한 문서 ID가 있는지 확인
   - 예: 계산된 코드가 `SABN`이면 `SABN` 문서가 있어야 함
3. 각 문서의 필드가 모두 입력되었는지 확인:
   - `code` (string)
   - `name` (string)
   - `description` (string)
   - `imageUrl` (string)
   - `traits` (map)
   - `destinations` (array)

### 3. 가능한 원인

#### 원인 1: 유형 코드 불일치
- 계산된 유형 코드가 Firestore에 없음
- **해결**: Firestore의 types 컬렉션에 해당 유형 추가

#### 원인 2: 데이터 형식 오류
- Firestore의 데이터 형식이 앱에서 기대하는 형식과 다름
- **해결**: `firestore_data.json`과 비교하여 형식 확인

#### 원인 3: 네트워크 오류
- Firestore 연결 실패
- **해결**: 인터넷 연결 확인, Firebase 프로젝트 설정 확인

## 🔧 해결 방법

### 방법 1: Firestore 데이터 재확인

1. [Firestore Console](https://console.firebase.google.com/project/travely-mbti/firestore) 접속
2. **types** 컬렉션 확인
3. 16개 유형이 모두 있는지 확인:
   - SABN, SABC, SALN, SALC
   - SRBN, SRBC, SRLN, SRLC
   - PABN, PABC, PALN, PALC
   - PRBN, PRBC, PRLN, PRLC

### 방법 2: 데이터 재입력

스크립트를 다시 실행:

```bash
node scripts/import_types_only.js
```

### 방법 3: 수동 확인

브라우저 콘솔에서 확인한 유형 코드로:
1. Firestore Console에서 해당 문서 확인
2. 문서가 없으면 추가
3. 문서가 있으면 필드 확인

## 📝 수정 사항

다음 수정이 적용되었습니다:

1. ✅ `travelType`이 null일 때 에러 메시지 표시
2. ✅ 디버깅 로그 추가
3. ✅ 사용자 친화적 에러 화면

## 🚀 다음 단계

1. 웹사이트 재배포 완료 후 테스트
2. 브라우저 콘솔에서 로그 확인
3. 계산된 유형 코드 확인
4. Firestore에 해당 유형이 있는지 확인


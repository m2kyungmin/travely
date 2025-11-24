# 데이터 입력 확인 가이드

## ✅ 데이터 입력 완료!

이제 데이터가 제대로 입력되었는지 확인하고 앱을 테스트하세요.

## 확인 방법

### 방법 1: Firebase Console에서 확인 (가장 간단)

1. [Firestore Console](https://console.firebase.google.com/project/travely-mbti/firestore) 접속
2. 확인 사항:
   - **questions** 컬렉션: 16개 문서 (q1 ~ q16)
   - **types** 컬렉션: 16개 문서 (SABN, SABC, ..., PRLC)

### 방법 2: 앱 실행하여 확인

앱을 실행하면 자동으로 Firestore에서 데이터를 가져옵니다.

```bash
# 웹에서 테스트
flutter run -d chrome

# 또는 모바일 에뮬레이터
flutter run
```

## 예상 동작

1. **스플래시 화면** → Firebase 초기화
2. **홈 화면** → "테스트 시작하기" 버튼 표시
3. **테스트 화면** → 16개 질문이 순서대로 표시
4. **로딩 화면** → 결과 계산 중
5. **결과 화면** → 여행 유형 및 추천 여행지 표시

## 문제 해결

### 질문이 표시되지 않는 경우

1. Firebase Console에서 questions 컬렉션 확인
2. 각 문서의 필드가 모두 입력되었는지 확인
3. 앱 재시작

### 결과가 표시되지 않는 경우

1. Firebase Console에서 types 컬렉션 확인
2. 유형 코드가 정확한지 확인 (SABN, SABC, ...)
3. 앱 재시작

### Firebase 연결 오류

1. `firebase_options.dart` 파일 확인
2. 인터넷 연결 확인
3. Firebase 프로젝트 설정 확인

## 다음 단계

데이터가 정상적으로 표시되면:

1. ✅ **보안 규칙 설정** (중요!)
2. ✅ **실제 이미지 URL 설정**
3. ✅ **실제 제휴 링크 설정**
4. ✅ **AdMob 실제 광고 ID 설정**


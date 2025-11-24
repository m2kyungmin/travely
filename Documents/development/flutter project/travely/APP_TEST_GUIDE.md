# 앱 테스트 가이드

## ✅ 데이터 입력 완료!

이제 앱을 테스트하여 모든 기능이 정상 작동하는지 확인하세요.

## 테스트 방법

### 1. 웹에서 테스트 (가장 빠름)

```bash
cd "/Users/leekyungmin/Documents/development/flutter project/travely"
flutter run -d chrome
```

또는 배포된 웹사이트에서 테스트:
- https://travely-mbti.web.app

### 2. 모바일 에뮬레이터에서 테스트

```bash
# Android 에뮬레이터
flutter run

# iOS 시뮬레이터
flutter run -d iPhone
```

## 테스트 체크리스트

### 기본 기능

- [ ] 앱이 정상적으로 시작됨
- [ ] 스플래시 화면 표시
- [ ] 홈 화면에 "테스트 시작하기" 버튼 표시
- [ ] 테스트 시작 버튼 클릭 시 테스트 화면으로 이동

### 질문 화면

- [ ] 16개 질문이 순서대로 표시됨
- [ ] 각 질문에 2개의 선택지가 표시됨
- [ ] 선택지 클릭 시 다음 질문으로 이동
- [ ] 진행률 바가 정상적으로 업데이트됨
- [ ] 이전 질문으로 돌아갈 수 있음

### 결과 화면

- [ ] 로딩 화면이 표시됨 (최소 3초)
- [ ] 결과 화면에 여행 유형이 표시됨
- [ ] 유형 이름, 설명이 표시됨
- [ ] 성향 분석 (traits)이 표시됨
- [ ] 추천 여행지 3개가 표시됨
- [ ] "결과 공유하기" 버튼 작동
- [ ] "다시 테스트하기" 버튼 작동

### 추가 기능

- [ ] 배너 광고 표시 (웹에서는 표시 안 될 수 있음)
- [ ] 공유 기능 작동
- [ ] 이전 결과 보기 기능

## 예상되는 문제 및 해결

### 질문이 표시되지 않는 경우

**원인**: Firestore 데이터가 제대로 입력되지 않음

**해결**:
1. [Firebase Console](https://console.firebase.google.com/project/travely-mbti/firestore)에서 questions 컬렉션 확인
2. 16개 문서 (q1 ~ q16)가 있는지 확인
3. 각 문서에 필드가 모두 입력되었는지 확인
4. 앱 재시작

### 결과가 표시되지 않는 경우

**원인**: types 컬렉션 데이터 문제

**해결**:
1. [Firebase Console](https://console.firebase.google.com/project/travely-mbti/firestore)에서 types 컬렉션 확인
2. 16개 문서 (SABN, SABC, ..., PRLC)가 있는지 확인
3. 각 문서의 필드가 모두 입력되었는지 확인
4. 앱 재시작

### Firebase 연결 오류

**원인**: 네트워크 또는 Firebase 설정 문제

**해결**:
1. 인터넷 연결 확인
2. `firebase_options.dart` 파일 확인
3. Firebase Console에서 프로젝트 상태 확인

## 다음 단계

테스트가 성공적으로 완료되면:

1. ✅ **보안 규칙 설정** - `FIRESTORE_SECURITY_RULES.md` 참고
2. ✅ **실제 이미지 URL 설정** - placeholder 이미지 URL 교체
3. ✅ **실제 제휴 링크 설정** - 예시 링크를 실제 링크로 교체
4. ✅ **AdMob 실제 광고 ID 설정** - 테스트 ID를 실제 ID로 교체
5. ✅ **OG 이미지 준비** - SNS 공유용 이미지 (1200x630px)

## 완료!

모든 테스트가 통과하면 앱이 정상적으로 작동하는 것입니다! 🎉


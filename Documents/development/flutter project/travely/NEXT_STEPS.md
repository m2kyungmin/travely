# 다음 단계 가이드

## ✅ 완료된 작업

- [x] Firebase 프로젝트 생성 및 연동
- [x] Flutter 앱 웹 빌드 및 배포
- [x] Firebase Hosting 배포 완료
- [x] 웹사이트 배포: https://travely-mbti.web.app

## 🔄 다음 단계

### 1. Firestore Database 활성화 (필수)

Firestore가 아직 활성화되지 않았습니다. 다음 단계를 진행하세요:

#### 방법 A: Firebase Console에서 활성화 (권장)

1. [Firebase Console](https://console.firebase.google.com/project/travely-mbti) 접속
2. 왼쪽 메뉴에서 **"Firestore Database"** 클릭
3. **"데이터베이스 만들기"** 클릭
4. 설정 선택:
   - **모드**: "테스트 모드로 시작" 선택
   - **위치**: `asia-northeast3` (서울) 권장
5. **"사용 설정"** 클릭

또는 직접 링크:
👉 [Firestore 활성화](https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=travely-mbti)

### 2. Firestore 데이터 입력

Firestore가 활성화되면 데이터를 입력하세요:

#### 빠른 방법: Firebase Console에서 수동 입력

**questions 컬렉션:**
1. Firestore Database → "컬렉션 시작"
2. 컬렉션 ID: `questions`
3. 문서 ID: `q1`, `q2`, ..., `q16` (16개)
4. 각 문서에 필드 추가:
   - `order` (number)
   - `text` (string)
   - `optionA` (string)
   - `optionB` (string)
   - `axis` (string)
   - `scoreA` (string)
   - `scoreB` (string)

**types 컬렉션:**
1. "컬렉션 시작"
2. 컬렉션 ID: `types`
3. 문서 ID: `SABN`, `SABC`, ..., `PRLC` (16개)
4. 각 문서에 필드 추가:
   - `code` (string)
   - `name` (string)
   - `description` (string)
   - `imageUrl` (string)
   - `traits` (map) - 4개 필드
   - `destinations` (array) - 3개 항목

📄 **자세한 가이드**: `FIRESTORE_QUICK_IMPORT.md` 참고

### 3. Firestore 보안 규칙 설정

데이터 입력 후 보안 규칙을 설정하세요:

Firebase Console → Firestore Database → 규칙

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /questions/{questionId} {
      allow read: if true;
      allow write: if false;
    }
    match /types/{typeId} {
      allow read: if true;
      allow write: if false;
    }
    match /results/{resultId} {
      allow read, write: if true;
    }
  }
}
```

### 4. 앱 테스트

데이터 입력 완료 후:

```bash
# 앱 실행
flutter run

# 또는 웹에서 테스트
flutter run -d chrome
```

### 5. 추가 설정 (선택)

- [ ] 실제 이미지 URL 설정
- [ ] 실제 제휴 링크 설정
- [ ] AdMob 실제 광고 ID 설정
- [ ] 커스텀 도메인 연결
- [ ] OG 이미지 준비 및 업로드

## 📚 참고 문서

- `FIRESTORE_QUICK_IMPORT.md` - Firestore 데이터 입력 가이드
- `FIRESTORE_DATA_IMPORT.md` - 자동화 스크립트 사용법
- `FIREBASE_WEB_DEPLOY.md` - 웹 배포 가이드

## 🎯 우선순위

1. **Firestore 활성화** (지금 바로!)
2. **데이터 입력** (questions, types)
3. **앱 테스트**
4. **보안 규칙 설정**

Firestore를 활성화하시면 데이터 입력을 도와드리겠습니다!


# Firestore 보안 규칙 설정

## ⚠️ 중요: 보안 규칙 설정 필수!

현재 Firestore는 "테스트 모드"로 시작했기 때문에 누구나 읽기/쓰기가 가능합니다.
프로덕션 환경에서는 반드시 보안 규칙을 설정해야 합니다.

## 보안 규칙 설정 방법

1. [Firebase Console - Firestore 규칙](https://console.firebase.google.com/project/travely-mbti/firestore/rules) 접속
2. 다음 규칙을 복사하여 붙여넣기:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // questions 컬렉션: 읽기만 허용
    match /questions/{questionId} {
      allow read: if true;
      allow write: if false;
    }
    
    // types 컬렉션: 읽기만 허용
    match /types/{typeId} {
      allow read: if true;
      allow write: if false;
    }
    
    // results 컬렉션: 읽기/쓰기 모두 허용 (통계용)
    match /results/{resultId} {
      allow read, write: if true;
    }
  }
}
```

3. **"게시"** 버튼 클릭

## 규칙 설명

- **questions**: 모든 사용자가 읽을 수 있지만, 쓰기는 불가능 (관리자만 수정)
- **types**: 모든 사용자가 읽을 수 있지만, 쓰기는 불가능 (관리자만 수정)
- **results**: 모든 사용자가 읽고 쓸 수 있음 (테스트 결과 통계 저장용)

## 더 강화된 보안 규칙 (선택)

인증을 사용하는 경우:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // questions: 인증된 사용자만 읽기 가능
    match /questions/{questionId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // types: 인증된 사용자만 읽기 가능
    match /types/{typeId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // results: 본인이 작성한 결과만 읽기/쓰기 가능
    match /results/{resultId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
  }
}
```

## 테스트 모드 유지 (개발 중)

개발 중에는 테스트 모드로 유지해도 되지만, **반드시 프로덕션 배포 전에 보안 규칙을 설정**하세요!


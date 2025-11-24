# Firestore 데이터 입력 가이드

## 방법 1: Firebase Console에서 수동 입력 (가장 간단)

### questions 컬렉션 입력

1. Firebase Console → Firestore Database 접속
2. "컬렉션 시작" 클릭
3. 컬렉션 ID: `questions` 입력
4. 각 질문을 문서로 추가:
   - 문서 ID: `q1`, `q2`, ..., `q16`
   - 필드 추가:
     - `order` (number): 1, 2, ..., 16
     - `text` (string): 질문 내용
     - `optionA` (string): 선택지 A
     - `optionB` (string): 선택지 B
     - `axis` (string): rhythm, energy, budget, concept
     - `scoreA` (string): S, P, A, R, B, L, N, C
     - `scoreB` (string): S, P, A, R, B, L, N, C

### types 컬렉션 입력

1. "컬렉션 시작" 클릭
2. 컬렉션 ID: `types` 입력
3. 각 유형을 문서로 추가:
   - 문서 ID: `SABN`, `SABC`, ..., `PRLC` (16개)
   - 필드 추가:
     - `code` (string): 유형 코드
     - `name` (string): 유형 이름
     - `description` (string): 설명
     - `imageUrl` (string): 이미지 URL
     - `traits` (map):
       - `rhythm` (string)
       - `energy` (string)
       - `budget` (string)
       - `concept` (string)
     - `destinations` (array):
       - 각 항목은 map:
         - `name` (string)
         - `description` (string)
         - `imageUrl` (string)
         - `affiliateLink` (string)

## 방법 2: Node.js 스크립트 사용 (자동화)

### 준비사항

1. **서비스 계정 키 다운로드**

   - Firebase Console → 프로젝트 설정 → 서비스 계정
   - "새 비공개 키 생성" 클릭
   - `serviceAccountKey.json` 파일을 프로젝트 루트에 저장

2. **Node.js 패키지 설치**

   ```bash
   npm init -y
   npm install firebase-admin
   ```

3. **스크립트 실행**
   ```bash
   node scripts/import_firestore.js
   ```

## 방법 3: Python 스크립트 사용 (자동화)

### 준비사항

1. **서비스 계정 키 다운로드** (위와 동일)

2. **Python 패키지 설치**

   ```bash
   pip install firebase-admin
   ```

3. **스크립트 실행**
   ```bash
   python3 scripts/import_firestore_python.py
   ```

## 방법 4: Firebase CLI 사용 (선택적)

Firebase CLI로 직접 JSON을 import할 수 있습니다:

```bash
# questions 컬렉션만 import
firebase firestore:import --collection questions questions.json

# types 컬렉션만 import
firebase firestore:import --collection types types.json
```

## 데이터 확인

입력 후 Firebase Console에서 확인:

1. Firestore Database → questions 컬렉션 (16개 문서)
2. Firestore Database → types 컬렉션 (16개 문서)

## 주의사항

- ⚠️ **서비스 계정 키는 절대 Git에 커밋하지 마세요!**
- `.gitignore`에 `serviceAccountKey.json` 추가
- 실제 이미지 URL과 제휴 링크로 교체 필요
- Placeholder 데이터는 실제 콘텐츠로 교체 필요

## 빠른 시작 (수동 입력)

가장 빠른 방법은 Firebase Console에서 직접 입력하는 것입니다:

1. `firestore_data.json` 파일 열기
2. `questions` 배열의 각 항목을 복사
3. Firebase Console에서 문서 생성 후 필드에 붙여넣기
4. `types` 객체의 각 항목도 동일하게 반복

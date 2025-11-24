# Firebase Hosting 웹 배포 가이드

## 📋 사전 준비

1. **Firebase CLI 설치**
   ```bash
   npm install -g firebase-tools
   ```

2. **Firebase 로그인**
   ```bash
   firebase login
   ```

3. **Firebase 프로젝트 생성** (이미 있다면 생략)
   - [Firebase Console](https://console.firebase.google.com/)에서 프로젝트 생성

## 🚀 배포 단계

### 1. Flutter 웹 빌드

```bash
flutter build web --release
```

빌드가 완료되면 `build/web` 디렉토리에 웹 파일이 생성됩니다.

### 2. Firebase 초기화

```bash
firebase init hosting
```

초기화 과정에서 다음을 선택/입력:

- **What do you want to use as your public directory?** → `build/web`
- **Configure as a single-page app (rewrite all urls to /index.html)?** → `Yes`
- **Set up automatic builds and deploys with GitHub?** → `No` (또는 원하면 Yes)
- **File build/web/index.html already exists. Overwrite?** → `No`

### 3. Firebase 배포

```bash
firebase deploy --only hosting
```

또는 전체 배포:

```bash
firebase deploy
```

## 📝 설정 파일 설명

### firebase.json

- **public**: 빌드된 웹 파일이 있는 디렉토리 (`build/web`)
- **rewrites**: 모든 경로를 `index.html`로 리다이렉트 (SPA 지원)
- **headers**: 
  - 정적 파일 캐싱 (1년)
  - 보안 헤더 설정

### web/index.html

- ✅ SEO 메타 태그 (title, description, keywords)
- ✅ Open Graph 태그 (Facebook, 카카오톡 공유)
- ✅ Twitter Card 태그
- ✅ PWA 설정 (manifest.json 연결)
- ✅ 커스텀 로딩 스피너
- ✅ iOS Safari 최적화

### web/manifest.json

- ✅ PWA 앱 정보
- ✅ 테마 컬러 (#4A90D9)
- ✅ 아이콘 설정
- ✅ 바로가기 (Shortcuts)

## 🎨 OG 이미지 준비

공유 시 표시될 OG 이미지를 준비하세요:

1. **이미지 크기**: 1200x630px (권장)
2. **파일명**: `og-image.png`
3. **위치**: `web/og-image.png` 또는 CDN URL
4. **내용**: 앱 로고 + "트래블리 - 나만의 여행 MBTI" 텍스트

배포 후 `https://your-domain.com/og-image.png`로 접근 가능하도록 설정하거나, CDN URL을 사용하세요.

## 🔧 추가 최적화

### 1. 도메인 연결

Firebase Console → Hosting → 도메인 추가

### 2. HTTPS 자동 설정

Firebase Hosting은 자동으로 HTTPS를 제공합니다.

### 3. CDN 캐싱

Firebase Hosting은 Google의 글로벌 CDN을 사용합니다.

### 4. 커스텀 도메인

1. Firebase Console → Hosting → 도메인 추가
2. DNS 레코드 추가 (A 레코드 또는 CNAME)
3. SSL 인증서 자동 발급 (몇 분 소요)

## 📊 배포 확인

배포 후 다음을 확인하세요:

- [ ] 웹사이트 정상 로드
- [ ] 모든 라우트 정상 동작
- [ ] 로딩 스피너 표시
- [ ] PWA 설치 가능
- [ ] OG 이미지 공유 시 표시
- [ ] 모바일 반응형 레이아웃

## 🔄 업데이트 배포

코드 수정 후 재배포:

```bash
# 1. 웹 빌드
flutter build web --release

# 2. 배포
firebase deploy --only hosting
```

## 🐛 문제 해결

### 빌드 오류

```bash
# Flutter 클린 빌드
flutter clean
flutter pub get
flutter build web --release
```

### 배포 오류

```bash
# Firebase 재로그인
firebase logout
firebase login

# 프로젝트 재연결
firebase use --add
```

### 캐시 문제

Firebase Hosting은 자동으로 캐시를 관리하지만, 강제 새로고침이 필요할 수 있습니다:
- `Ctrl + Shift + R` (Windows/Linux)
- `Cmd + Shift + R` (Mac)

## 📱 PWA 테스트

1. Chrome DevTools → Application → Manifest
2. Lighthouse → PWA 체크
3. 모바일에서 "홈 화면에 추가" 테스트

## 🔗 유용한 링크

- [Firebase Hosting 문서](https://firebase.google.com/docs/hosting)
- [Flutter 웹 배포 가이드](https://docs.flutter.dev/deployment/web)
- [PWA 체크리스트](https://web.dev/pwa-checklist/)


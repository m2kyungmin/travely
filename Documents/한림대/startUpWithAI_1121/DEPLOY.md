# 배포 가이드

Cook-K 랜딩 페이지를 배포하는 방법입니다.

## 🚀 배포 옵션

### 1. Vercel (추천 - 가장 쉬움)

Vercel은 Next.js를 만든 회사이므로 가장 간단하고 최적화된 배포 환경을 제공합니다.

#### 방법 1: Vercel 웹사이트를 통한 배포

1. **GitHub에 코드 업로드**

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin <your-github-repo-url>
   git push -u origin main
   ```

2. **Vercel에 배포**
   - [vercel.com](https://vercel.com)에 가입/로그인
   - "Add New Project" 클릭
   - GitHub 저장소 선택
   - 프로젝트 설정 확인 (자동으로 Next.js 감지)
   - "Deploy" 클릭
   - 몇 분 후 배포 완료!

#### 방법 2: Vercel CLI를 통한 배포

```bash
# Vercel CLI 설치
npm i -g vercel

# 배포
vercel

# 프로덕션 배포
vercel --prod
```

### 2. Netlify

1. **GitHub에 코드 업로드** (위와 동일)

2. **Netlify에 배포**
   - [netlify.com](https://netlify.com)에 가입/로그인
   - "Add new site" → "Import an existing project"
   - GitHub 저장소 선택
   - 빌드 설정:
     - Build command: `npm run build`
     - Publish directory: `.next`
   - "Deploy site" 클릭

### 3. GitHub Pages (정적 사이트)

Next.js를 정적 사이트로 내보낸 후 GitHub Pages에 배포:

```bash
# next.config.js에 output: 'export' 추가 필요
npm run build
# .next 폴더를 GitHub Pages에 업로드
```

### 4. 기타 클라우드 서비스

- **AWS Amplify**: AWS 계정 필요
- **Google Cloud Run**: Docker 컨테이너로 배포
- **Azure Static Web Apps**: Azure 계정 필요

## 📋 배포 전 체크리스트

- [x] 빌드 성공 확인 (`npm run build`)
- [ ] 환경 변수 설정 (필요한 경우)
- [ ] 도메인 설정 (선택사항)
- [ ] 이미지 최적화 확인
- [ ] SEO 메타 태그 확인

## 🔧 환경 변수 (필요한 경우)

현재 프로젝트는 환경 변수가 필요하지 않지만, 향후 추가할 수 있습니다:

```bash
# .env.local 파일 생성
NEXT_PUBLIC_API_URL=https://api.example.com
```

## 🌐 커스텀 도메인 설정

### Vercel

1. 프로젝트 설정 → Domains
2. 원하는 도메인 입력
3. DNS 설정 안내에 따라 도메인 연결

### Netlify

1. Site settings → Domain management
2. "Add custom domain" 클릭
3. DNS 설정 안내에 따라 도메인 연결

## 📊 성능 최적화

배포 후 다음을 확인하세요:

- [PageSpeed Insights](https://pagespeed.web.dev/)로 성능 테스트
- 이미지 최적화 확인
- 번들 크기 확인

## 🆘 문제 해결

### 빌드 실패

- `npm run build` 로컬에서 실행하여 오류 확인
- TypeScript 오류 수정
- 의존성 재설치: `rm -rf node_modules && npm install`

### 이미지 로드 실패

#### 로컬 이미지가 배포 후 안 보이는 경우

1. **Git에 이미지가 포함되었는지 확인**

   ```bash
   git status
   # public/images/ 폴더가 표시되는지 확인
   ```

2. **이미지가 Git에 포함되도록 추가**

   ```bash
   git add public/images/
   git commit -m "Add local images"
   git push
   ```

3. **`.gitignore` 확인**

   - `public/` 폴더가 `.gitignore`에 포함되어 있지 않은지 확인
   - `public/` 폴더는 **반드시 Git에 포함**되어야 합니다

4. **배포 플랫폼에서 재배포**

   - Git에 이미지를 추가한 후 다시 배포
   - Vercel/Netlify는 자동으로 재배포됩니다

5. **이미지 경로 확인**

   - 모든 이미지 경로가 `/images/...` 형식인지 확인 (절대 경로)
   - `public/images/cook-k.jpeg` → `/images/cook-k.jpeg`

6. **빌드 로그 확인**
   - 배포 플랫폼의 빌드 로그에서 이미지 파일이 복사되었는지 확인
   - `public` 폴더가 빌드 출력에 포함되는지 확인

## 💡 추천 배포 플랫폼

**Vercel**을 강력히 추천합니다:

- ✅ Next.js 최적화
- ✅ 자동 HTTPS
- ✅ 글로벌 CDN
- ✅ 무료 플랜 제공
- ✅ 자동 배포 (Git push 시)
- ✅ 프리뷰 배포 (Pull Request마다)

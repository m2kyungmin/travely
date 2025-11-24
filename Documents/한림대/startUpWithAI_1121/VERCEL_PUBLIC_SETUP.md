# Vercel 공개 배포 설정 가이드 (2024 업데이트)

Vercel에 배포한 웹사이트를 로그인 없이 누구나 볼 수 있도록 설정하는 방법입니다.

## 🔓 공개 설정 방법 (실제 위치)

### 방법 1: Deployment Protection 확인 (가장 중요!)

1. **Vercel 대시보드 접속**
   - [vercel.com/dashboard](https://vercel.com/dashboard)에 로그인
   - 배포한 프로젝트 클릭

2. **Settings → Deployments**
   - 왼쪽 메뉴에서 "Settings" 클릭
   - "Deployments" 탭 선택
   - **"Deployment Protection"** 섹션 확인

3. **보호 기능 비활성화**
   - "Password Protection" → **비활성화**
   - "Vercel Authentication" → **비활성화**
   - "IP Allowlist" → **비활성화** (활성화되어 있다면)
   - 저장

### 방법 2: 프로덕션 배포 URL 확인

**중요**: 프리뷰 배포가 아닌 **프로덕션 배포**를 확인해야 합니다.

1. 프로젝트 대시보드에서
2. 상단의 배포 목록 확인
3. **"Production"** 태그가 있는 배포 찾기
4. 해당 배포의 URL 클릭 또는 복사
   - 형식: `https://your-project-name.vercel.app`
   - **NOT** `https://your-project-name-git-xxx.vercel.app` (이건 프리뷰)

### 방법 3: 새 프로덕션 배포 생성

만약 설정이 복잡하다면, 새로 배포해보세요:

```bash
# 프로젝트 폴더에서
vercel --prod
```

또는 GitHub에 push하면 자동으로 프로덕션 배포가 생성됩니다.

## 🔍 문제 진단

### 로그인 화면이 보이는 경우 체크리스트

1. **올바른 URL인가?**
   - ✅ `https://your-project.vercel.app` (프로덕션)
   - ❌ `https://your-project-git-main.vercel.app` (프리뷰)
   - ❌ `https://your-project-xxx.vercel.app` (프리뷰)

2. **Deployment Protection이 활성화되어 있는가?**
   - Settings → Deployments 확인
   - 모든 보호 기능 비활성화

3. **프로덕션 배포가 있는가?**
   - 대시보드에서 "Production" 배포 확인
   - 없다면 새로 배포 필요

4. **브라우저 캐시 문제인가?**
   - 시크릿 모드에서 테스트
   - 다른 브라우저에서 테스트

## 📝 단계별 해결 가이드

### Step 1: 배포 목록 확인
```
Vercel 대시보드
  └─ 프로젝트 선택
      └─ 상단 배포 목록
          └─ "Production" 태그 확인
```

### Step 2: Settings 확인
```
Settings (왼쪽 메뉴)
  └─ Deployments 탭
      └─ Deployment Protection 섹션
          └─ 모든 옵션 OFF
```

### Step 3: 프로덕션 배포 URL 복사
```
배포 카드
  └─ "Production" 태그가 있는 배포
      └─ URL 클릭 또는 복사
```

### Step 4: 테스트
```
시크릿 모드 브라우저
  └─ URL 접속
      └─ 로그인 없이 접근 가능한지 확인
```

## 🆘 여전히 안 된다면

### 옵션 1: Vercel CLI로 재배포
```bash
# 프로젝트 폴더에서
vercel --prod --force
```

### 옵션 2: GitHub 연동 확인
- GitHub 저장소가 Private인지 확인
- Private 저장소여도 Vercel 배포는 공개 가능
- Settings → Git에서 저장소 연결 확인

### 옵션 3: 새 프로젝트로 배포
1. 기존 프로젝트 삭제 (선택사항)
2. 새로 배포: `vercel --prod`
3. 배포 시 모든 질문에 기본값 선택

## 💡 Vercel 기본 동작

**중요**: Vercel은 기본적으로 모든 배포를 **공개**로 만듭니다.

- 프로덕션 배포: 자동으로 공개
- 프리뷰 배포: 기본적으로 공개 (설정에 따라 다를 수 있음)
- 로그인 화면이 보인다면 → Deployment Protection이 활성화된 것

## 🔗 올바른 URL 형식

```
✅ 공개 URL (프로덕션)
https://your-project-name.vercel.app

✅ 커스텀 도메인 (설정한 경우)
https://yourdomain.com

❌ 프리뷰 URL (로그인 필요할 수 있음)
https://your-project-name-git-main-username.vercel.app
```

## 📞 추가 도움

1. **Vercel 문서**: [vercel.com/docs](https://vercel.com/docs)
2. **지원팀**: 대시보드 → Help → Contact Support
3. **커뮤니티**: [github.com/vercel/vercel/discussions](https://github.com/vercel/vercel/discussions)

# Vercel 배포 후 이미지가 안 보이는 문제 해결

## 🔍 문제 원인

1. **Git에 이미지가 포함되지 않음** (가장 흔한 원인)
2. **한글 파일명 문제** (일부 환경에서 인코딩 문제)
3. **빌드 시 이미지가 복사되지 않음**

## ✅ 해결 방법

### 1단계: Git에 이미지 추가

```bash
# 현재 디렉토리에서 실행
cd /Users/leekyungmin/Documents/한림대/startUpWithAI_1121

# 이미지 파일들을 Git에 추가
git add public/images/

# 커밋
git commit -m "Add local images for Vercel deployment"

# GitHub에 푸시 (Vercel이 자동으로 재배포)
git push
```

### 2단계: Vercel에서 재배포 확인

1. Vercel 대시보드 접속
2. 프로젝트 선택
3. "Deployments" 탭 확인
4. 새로운 배포가 자동으로 시작되는지 확인
5. 배포 완료 후 이미지 확인

### 3단계: 빌드 로그 확인

Vercel 대시보드에서:
1. 최신 배포 클릭
2. "Build Logs" 확인
3. `public` 폴더가 복사되었는지 확인
4. 에러 메시지 확인

### 4단계: 브라우저에서 확인

1. 배포된 사이트 접속
2. 개발자 도구 열기 (F12)
3. Network 탭 확인
4. 이미지 요청이 404인지 확인
5. 이미지 URL이 올바른지 확인

## 🚨 한글 파일명 문제 해결 (선택사항)

한글 파일명이 문제가 될 수 있습니다. 영문으로 변경하는 것을 권장합니다:

```bash
# 파일명 변경 예시
mv public/images/boxes/김치전.jpeg public/images/boxes/kimchi-jeon.jpeg
mv public/images/boxes/닭강정.jpeg public/images/boxes/dakgangjeong.jpeg
mv public/images/boxes/떡볶이.jpeg public/images/boxes/tteokbokki.jpeg
mv public/images/boxes/불고기.jpeg public/images/boxes/bulgogi.jpeg
mv public/images/boxes/비빔밥.jpeg public/images/boxes/bibimbap.jpeg
mv public/images/boxes/갈비찜.jpeg public/images/boxes/galbi-jjim.jpeg
mv public/images/boxes/비건-김밥.jpeg public/images/boxes/vegan-kimbap.jpeg
mv public/images/boxes/비건-잡채.jpeg public/images/boxes/vegan-japchae.jpeg
mv public/images/boxes/비건-순두부찌개.jpeg public/images/boxes/vegan-sundubu-jjigae.jpeg
```

파일명 변경 후 코드도 업데이트해야 합니다.

## 📝 체크리스트

- [ ] `git add public/images/` 실행
- [ ] `git commit` 실행
- [ ] `git push` 실행
- [ ] Vercel에서 자동 재배포 확인
- [ ] 배포 완료 후 이미지 확인
- [ ] 브라우저 개발자 도구에서 404 에러 확인

## 💡 추가 팁

### Vercel 환경 변수 확인
- 일반적으로 필요 없지만, 특별한 설정이 있다면 확인

### Next.js Image 최적화
- Next.js Image 컴포넌트는 자동으로 최적화합니다
- `next.config.js`에서 추가 설정이 필요 없습니다

### 캐시 문제
- 브라우저 캐시를 지우고 다시 시도
- 시크릿 모드에서 확인

## 🆘 여전히 안 되면

1. Vercel 대시보드의 "Functions" 탭에서 에러 확인
2. Vercel 로그에서 이미지 경로 확인
3. `public` 폴더 구조 확인
4. 이미지 파일 크기 확인 (너무 크면 문제될 수 있음)


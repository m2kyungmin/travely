# GitHub 저장소 연결 가이드

## ✅ 완료된 작업
- ✅ 모든 파일 Git에 추가 완료
- ✅ 이미지 파일 포함 완료
- ✅ 첫 커밋 완료

## 🔗 다음 단계: GitHub 저장소 연결

### 방법 1: GitHub 웹사이트에서 저장소 만들기 (추천)

1. **GitHub.com 접속**
   - https://github.com 에 로그인

2. **새 저장소 만들기**
   - 오른쪽 상단 "+" 버튼 클릭
   - "New repository" 선택
   - Repository name: `cook-k-landing` (원하는 이름)
   - Public 또는 Private 선택
   - **"Initialize this repository with a README" 체크 해제** (이미 파일이 있으므로)
   - "Create repository" 클릭

3. **저장소 URL 복사**
   - 생성된 페이지에서 URL 복사
   - 예: `https://github.com/your-username/cook-k-landing.git`

4. **터미널에서 연결**
   ```bash
   cd /Users/leekyungmin/Documents/한림대/startUpWithAI_1121
   git remote add origin https://github.com/your-username/cook-k-landing.git
   git branch -M main
   git push -u origin main
   ```

### 방법 2: GitHub CLI 사용 (터미널에서 바로)

```bash
# GitHub CLI 설치 (없는 경우)
brew install gh

# GitHub 로그인
gh auth login

# 저장소 생성 및 연결
gh repo create cook-k-landing --public --source=. --remote=origin --push
```

## 📝 저장소 URL을 알려주시면

저장소 URL을 알려주시면 제가 바로 연결해드리겠습니다!

예시:
- `https://github.com/your-username/cook-k-landing.git`

## 🎯 Vercel 연결

GitHub에 푸시한 후:
1. Vercel 대시보드 접속
2. "Add New Project" 클릭
3. 방금 만든 GitHub 저장소 선택
4. 자동으로 배포 시작!


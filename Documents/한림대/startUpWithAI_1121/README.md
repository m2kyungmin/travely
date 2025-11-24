# Cook-K Landing Page

모던하고 시각적으로 매력적인 한국 음식 밀키트 구독 서비스 랜딩 페이지입니다.

## 기술 스택

- **Next.js 14** (App Router)
- **TypeScript**
- **Tailwind CSS**
- **Framer Motion** (애니메이션)
- **Lucide React** (아이콘)

## 프로젝트 구조

```
/app
  /page.tsx          # 메인 랜딩 페이지
  /layout.tsx        # 루트 레이아웃
  /globals.css      # 글로벌 스타일

/components
  /Hero.tsx          # 히어로 섹션
  /PainPoints.tsx    # 문제-해결 섹션
  /Benefits.tsx      # 혜택 섹션
  /ProductCarousel.tsx # 제품 캐러셀
  /HowItWorks.tsx    # 작동 방식
  /Testimonials.tsx  # 고객 후기
  /Pricing.tsx       # 가격 정보
  /Footer.tsx        # 푸터
  /ui
    /Button.tsx      # 버튼 컴포넌트
    /Card.tsx        # 카드 컴포넌트
    /Badge.tsx       # 배지 컴포넌트

/data
  /mealkits.ts      # 밀키트 샘플 데이터

/types
  /index.ts         # TypeScript 타입 정의
```

## 시작하기

### 1. 의존성 설치

```bash
npm install
```

### 2. 개발 서버 실행

```bash
npm run dev
```

브라우저에서 [http://localhost:3000](http://localhost:3000)을 열어 확인하세요.

### 3. 프로덕션 빌드

```bash
npm run build
npm start
```

## 주요 기능

- ✅ 반응형 디자인 (모바일 우선)
- ✅ Framer Motion을 활용한 부드러운 스크롤 애니메이션
- ✅ Intersection Observer를 통한 스크롤 트리거 애니메이션
- ✅ SEO 최적화된 메타 태그
- ✅ Next.js Image 최적화
- ✅ 다크 모드 지원 준비
- ✅ i18n 준비 (다국어 지원 구조)

## 디자인 특징

- **컬러 팔레트**: 
  - Primary Red: #E53935
  - Warm Orange: #FF6F00
  - Cream White: #FFF8E1
  - Dark Charcoal: #212121

- **한국 문화 요소**: 전통 패턴과 브러시 스트로크 악센트 포함

## 섹션 구성

1. **Hero Section**: 비디오/이미지 배경, CTA 버튼, 요리 시간 배지
2. **Problem-Solution**: 3가지 주요 문제점과 해결책
3. **Benefits**: 4가지 주요 혜택
4. **Product Showcase**: 가로 스크롤 가능한 밀키트 캐러셀
5. **How It Works**: 3단계 프로세스
6. **Social Proof**: 고객 후기 및 인스타그램 스타일 포토 그리드
7. **Pricing**: 3가지 구독 플랜
8. **Footer**: 네비게이션, 소셜 미디어, 뉴스레터 구독, 언어 선택기

## 커스터마이징

### 밀키트 데이터 수정

`/data/mealkits.ts` 파일에서 밀키트 정보를 수정할 수 있습니다.

### 색상 변경

`tailwind.config.ts` 파일에서 컬러 팔레트를 수정할 수 있습니다.

### 애니메이션 조정

각 컴포넌트의 Framer Motion 설정을 수정하여 애니메이션을 커스터마이징할 수 있습니다.

## 라이선스

이 프로젝트는 교육 목적으로 제작되었습니다.


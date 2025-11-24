"use client";

import { createContext, useContext, useState, ReactNode } from "react";

type Language = "ko" | "en";

interface LanguageContextType {
  language: Language;
  toggleLanguage: () => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextType | undefined>(
  undefined
);

// 번역 데이터
const translations: Record<Language, Record<string, string>> = {
  ko: {
    // Hero
    "hero.badge": "15-30분 조리 시간",
    "hero.title": "진정한 한국 맛,",
    "hero.titleHighlight": "당신의 주방으로 배송됩니다",
    "hero.subtitle":
      "완벽하게 계량된 재료와 쉬운 레시피로 한국의 맛을 경험하세요",
    "hero.cta.primary": "Cook-K 여정 시작하기",
    "hero.cta.secondary": "메뉴 보기",

    // Pricing
    "pricing.title": "Cook-K 경험 선택하기",
    "pricing.subtitle":
      "한국 문화를 탐험하거나, 채식 식단을 따르거나, 진정한 맛을 원하시나요? 당신에게 완벽한 박스가 있습니다.",
    "pricing.boxes": "K-Culture • K-Vegan • K-Traditional",
    "pricing.promotion": "첫 박스 30% 할인",
    "pricing.kCulture.name": "K-Culture",
    "pricing.kCulture.target": "K-드라마 & 문화 애호가",
    "pricing.kCulture.feature1": "큐레이션된 한국 음식 2식",
    "pricing.kCulture.feature2": "K-드라마 테마 포장재 & 컬렉터블",
    "pricing.kCulture.feature3": "문화 스토리 카드",
    "pricing.kCulture.feature4": "일회성 구매",
    "pricing.kCulture.feature5": "구독 후 추가 20% 할인",
    "pricing.kCulture.cta": "K-Culture 박스 시도하기",
    "pricing.kCulture.meals": "식 포함",
    "pricing.kVegan.name": "K-Vegan",
    "pricing.kVegan.target": "식물 기반 한국 요리",
    "pricing.kVegan.feature1": "주당 식물 기반 식사 2식",
    "pricing.kVegan.feature2": "100% 비건 재료",
    "pricing.kVegan.feature3": "무료 배송",
    "pricing.kVegan.feature4": "레시피 카드 + 비디오 튜토리얼",
    "pricing.kVegan.feature5": "언제든지 취소 가능",
    "pricing.kVegan.cta": "지금 구독하기",
    "pricing.kVegan.perMeal": "식당당",
    "pricing.kVegan.perWeek": "주당 식",
    "pricing.kTraditional.name": "K-Traditional",
    "pricing.kTraditional.target": "주간 진정한 맛",
    "pricing.kTraditional.feature1": "주당 진정한 한국 식사 3식",
    "pricing.kTraditional.feature2": "전통 레시피 & 기법",
    "pricing.kTraditional.feature3": "무료 배송",
    "pricing.kTraditional.feature4": "레시피 카드 + 비디오 튜토리얼",
    "pricing.kTraditional.feature5": "우선 고객 지원",
    "pricing.kTraditional.feature6": "언제든지 취소 가능",
    "pricing.kTraditional.cta": "지금 구독하기",
    "pricing.kTraditional.perMeal": "식당당",
    "pricing.kTraditional.perWeek": "주당 식",
    "pricing.oneTime": "일회성",
    "pricing.mostPopular": "가장 인기",
    "pricing.week": "/주",

    // Modal
    "modal.step.info": "정보",
    "modal.step.payment": "결제",
    "modal.step.confirmation": "완료",
    "modal.info.title": "배송 정보",
    "modal.info.firstName": "이름",
    "modal.info.lastName": "성",
    "modal.info.email": "이메일",
    "modal.info.phone": "전화번호",
    "modal.info.address": "주소",
    "modal.info.city": "도시",
    "modal.info.state": "주/도",
    "modal.info.zip": "우편번호",
    "modal.info.frequency": "배송 빈도",
    "modal.info.weekly": "매주",
    "modal.info.biweekly": "격주",
    "modal.info.monthly": "월 1회",
    "modal.info.deliveryDate": "첫 배송 날짜",
    "modal.payment.title": "결제 정보",
    "modal.payment.subscriptionNote": "구독은 언제든지 취소할 수 있습니다",
    "modal.payment.cardNumber": "카드 번호",
    "modal.payment.cardName": "카드 소유자 이름",
    "modal.payment.expiryDate": "만료일",
    "modal.payment.cvv": "CVV",
    "modal.payment.demoNote":
      "⚠️ 프레젠테이션용 가상 결제 시스템입니다. 실제 결제가 이루어지지 않습니다.",
    "modal.confirmation.title": "주문 완료!",
    "modal.confirmation.message": "주문이 성공적으로 완료되었습니다.",
    "modal.confirmation.emailNote": "주문 확인 이메일을 보내드렸습니다.",
    "modal.button.cancel": "취소",
    "modal.button.next": "다음",
    "modal.button.back": "뒤로",
    "modal.button.pay": "결제하기",
    "modal.button.close": "닫기",
    "comingSoon.title": "곧 출시 예정",
    "comingSoon.message": "메뉴 페이지가 곧 출시됩니다. 조금만 기다려주세요!",

    // Product Detail
    "product.includedMeals": "포함된 음식",
    "product.highlights": "이 박스의 특징",
    "product.whatsInside": "구성품",
    "product.button.close": "닫기",
    "product.button.subscribe": "구독하기",
    "product.button.learnMore": "상세 보기",
    "product.kCulture.meal1.description":
      "바삭하게 구운 김치전으로 한국의 전통 맛을 경험하세요.",
    "product.kCulture.meal2.description":
      "달콤하고 매콤한 양념의 바삭한 닭강정, K-드라마에서 자주 보는 인기 메뉴입니다.",
    "product.kCulture.meal3.description":
      "쫄깃한 떡과 매콤달콤한 고추장 소스의 완벽한 조합, 한국의 대표 길거리 음식입니다.",
    "product.kCulture.highlight1":
      "K-드라마 테마 포장재와 컬렉터블 아이템 포함",
    "product.kCulture.highlight2":
      "각 음식의 문화적 배경을 설명하는 스토리 카드 제공",
    "product.kCulture.highlight3":
      "한국 문화를 처음 접하는 분들에게 완벽한 시작점",
    "product.kCulture.content1": "신선한 재료 (각 음식별 완벽하게 계량됨)",
    "product.kCulture.content2": "전통 양념 및 소스 (사전 준비 완료)",
    "product.kCulture.content3": "단계별 레시피 카드 (한글/영문)",
    "product.kCulture.content4": "K-드라마 테마 소품 및 컬렉터블",
    "product.kVegan.meal1.description":
      "100% 식물성 재료로 만든 건강한 김밥, 다양한 채소가 들어간 영양 만점 메뉴입니다.",
    "product.kVegan.meal2.description":
      "고기 없이도 풍부한 맛을 내는 비건 잡채, 당면과 채소의 완벽한 조화입니다.",
    "product.kVegan.meal3.description":
      "부드러운 두부와 야채가 어우러진 따뜻한 비건 순두부찌개, 영양과 맛을 모두 잡았습니다.",
    "product.kVegan.highlight1": "100% 비건 인증 재료만 사용",
    "product.kVegan.highlight2": "GMO 프리, 유기농 재료 우선 사용",
    "product.kVegan.highlight3": "전통 한국 맛을 비건으로 재현",
    "product.kVegan.content1": "식물성 재료 (각 음식별 완벽하게 계량됨)",
    "product.kVegan.content2": "비건 전용 양념 및 소스",
    "product.kVegan.content3": "단계별 레시피 카드 + 비디오 튜토리얼",
    "product.kVegan.content4": "영양 정보 및 비건 인증 정보",
    "product.kTraditional.meal1.description":
      "부드럽게 양념된 얇은 고기, 한국의 대표적인 고기 요리입니다.",
    "product.kTraditional.meal2.description":
      "다양한 나물과 고추장이 어우러진 영양 만점 비빔밥, 한국의 대표 음식입니다.",
    "product.kTraditional.meal3.description":
      "부드럽게 조린 갈비찜, 전통 방식으로 만든 진정한 한국 맛입니다.",
    "product.kTraditional.highlight1": "전통 레시피와 조리법 그대로 재현",
    "product.kTraditional.highlight2": "한국 현지에서 공수한 정통 재료 사용",
    "product.kTraditional.highlight3": "레스토랑 수준의 품질을 집에서",
    "product.kTraditional.content1":
      "프리미엄 재료 (각 음식별 완벽하게 계량됨)",
    "product.kTraditional.content2": "전통 비법 양념 및 소스",
    "product.kTraditional.content3":
      "단계별 레시피 카드 + 전문가 비디오 튜토리얼",
    "product.kTraditional.content4": "전통 조리법 가이드 및 팁",
  },
  en: {
    // Hero
    "hero.badge": "15-30 min cooking time",
    "hero.title": "Authentic Korean Flavors,",
    "hero.titleHighlight": "Delivered to Your Kitchen",
    "hero.subtitle":
      "Experience the taste of Korea with perfectly portioned ingredients and easy-to-follow recipes",
    "hero.cta.primary": "Start Your Cook-K Journey",
    "hero.cta.secondary": "View Menu",

    // Pricing
    "pricing.title": "Choose Your Cook-K Experience",
    "pricing.subtitle":
      "Whether you're exploring Korean culture, following a plant-based diet, or craving authentic flavors - we have the perfect box for you.",
    "pricing.boxes": "K-Culture • K-Vegan • K-Traditional",
    "pricing.promotion": "First box 30% off",
    "pricing.kCulture.name": "K-Culture",
    "pricing.kCulture.target": "K-drama & Culture Enthusiasts",
    "pricing.kCulture.feature1": "3 curated Korean meals",
    "pricing.kCulture.feature2": "K-drama themed packaging & collectibles",
    "pricing.kCulture.feature3": "Cultural story cards",
    "pricing.kCulture.feature4": "One-time purchase",
    "pricing.kCulture.feature5": "Subscribe after to save 20% more",
    "pricing.kCulture.cta": "Try K-Culture Box",
    "pricing.kCulture.meals": "meals included",
    "pricing.kVegan.name": "K-Vegan",
    "pricing.kVegan.target": "Plant-Based Korean Cuisine",
    "pricing.kVegan.feature1": "3 plant-based meals per week",
    "pricing.kVegan.feature2": "100% vegan ingredients",
    "pricing.kVegan.feature3": "Free shipping",
    "pricing.kVegan.feature4": "Recipe cards + video tutorials",
    "pricing.kVegan.feature5": "Cancel anytime",
    "pricing.kVegan.cta": "Subscribe Now",
    "pricing.kVegan.perMeal": "per meal",
    "pricing.kVegan.perWeek": "meals per week",
    "pricing.kTraditional.name": "K-Traditional",
    "pricing.kTraditional.target": "Authentic Flavors Weekly",
    "pricing.kTraditional.feature1": "3 authentic Korean meals per week",
    "pricing.kTraditional.feature2": "Traditional recipes & techniques",
    "pricing.kTraditional.feature3": "Free shipping",
    "pricing.kTraditional.feature4": "Recipe cards + video tutorials",
    "pricing.kTraditional.feature5": "Priority customer support",
    "pricing.kTraditional.feature6": "Cancel anytime",
    "pricing.kTraditional.cta": "Subscribe Now",
    "pricing.kTraditional.perMeal": "per meal",
    "pricing.kTraditional.perWeek": "meals per week",
    "pricing.oneTime": "One-time",
    "pricing.mostPopular": "Most Popular",
    "pricing.week": "/week",

    // Modal
    "modal.step.info": "Info",
    "modal.step.payment": "Payment",
    "modal.step.confirmation": "Confirm",
    "modal.info.title": "Shipping Information",
    "modal.info.firstName": "First Name",
    "modal.info.lastName": "Last Name",
    "modal.info.email": "Email",
    "modal.info.phone": "Phone",
    "modal.info.address": "Address",
    "modal.info.city": "City",
    "modal.info.state": "State",
    "modal.info.zip": "ZIP Code",
    "modal.info.frequency": "Delivery Frequency",
    "modal.info.weekly": "Weekly",
    "modal.info.biweekly": "Bi-weekly",
    "modal.info.monthly": "Monthly",
    "modal.info.deliveryDate": "First Delivery Date",
    "modal.payment.title": "Payment Information",
    "modal.payment.subscriptionNote": "Subscription can be cancelled anytime",
    "modal.payment.cardNumber": "Card Number",
    "modal.payment.cardName": "Cardholder Name",
    "modal.payment.expiryDate": "Expiry Date",
    "modal.payment.cvv": "CVV",
    "modal.payment.demoNote":
      "⚠️ This is a demo payment system for presentation. No actual payment will be processed.",
    "modal.confirmation.title": "Order Complete!",
    "modal.confirmation.message": "Your order has been successfully placed.",
    "modal.confirmation.emailNote":
      "A confirmation email has been sent to your inbox.",
    "modal.button.cancel": "Cancel",
    "modal.button.next": "Next",
    "modal.button.back": "Back",
    "modal.button.pay": "Pay Now",
    "modal.button.close": "Close",
    "comingSoon.title": "Coming Soon",
    "comingSoon.message":
      "Menu page will be available soon. Please stay tuned!",

    // Product Detail
    "product.includedMeals": "Included Meals",
    "product.highlights": "What Makes This Box Special",
    "product.whatsInside": "What's Inside",
    "product.button.close": "Close",
    "product.button.subscribe": "Subscribe Now",
    "product.button.learnMore": "Show Detail",
    "product.kCulture.meal1.description":
      "Crispy kimchi pancakes that bring authentic Korean flavors to your kitchen.",
    "product.kCulture.meal2.description":
      "Sweet and spicy crispy fried chicken, a popular dish often seen in K-dramas.",
    "product.kCulture.meal3.description":
      "Chewy rice cakes in a sweet and spicy gochujang sauce, Korea's iconic street food.",
    "product.kCulture.highlight1":
      "K-drama themed packaging and collectible items included",
    "product.kCulture.highlight2":
      "Story cards explaining the cultural background of each dish",
    "product.kCulture.highlight3":
      "Perfect starting point for those new to Korean culture",
    "product.kCulture.content1":
      "Fresh ingredients (perfectly portioned for each dish)",
    "product.kCulture.content2":
      "Traditional seasonings and sauces (pre-prepared)",
    "product.kCulture.content3": "Step-by-step recipe cards (Korean/English)",
    "product.kCulture.content4": "K-drama themed collectibles and souvenirs",
    "product.kVegan.meal1.description":
      "Healthy kimbap made with 100% plant-based ingredients, packed with nutritious vegetables.",
    "product.kVegan.meal2.description":
      "Vegan japchae with rich flavors without meat, a perfect harmony of glass noodles and vegetables.",
    "product.kVegan.meal3.description":
      "Warm vegan sundubu jjigae with soft tofu and vegetables, combining nutrition and taste.",
    "product.kVegan.highlight1": "100% certified vegan ingredients only",
    "product.kVegan.highlight2": "GMO-free, organic ingredients prioritized",
    "product.kVegan.highlight3":
      "Traditional Korean flavors recreated as vegan",
    "product.kVegan.content1":
      "Plant-based ingredients (perfectly portioned for each dish)",
    "product.kVegan.content2": "Vegan-exclusive seasonings and sauces",
    "product.kVegan.content3": "Step-by-step recipe cards + video tutorials",
    "product.kVegan.content4":
      "Nutritional information and vegan certification",
    "product.kTraditional.meal1.description":
      "Tender marinated thinly sliced meat, Korea's representative meat dish.",
    "product.kTraditional.meal2.description":
      "Nutritious bibimbap with various vegetables and gochujang, Korea's signature dish.",
    "product.kTraditional.meal3.description":
      "Tender braised short ribs, authentic Korean flavors made the traditional way.",
    "product.kTraditional.highlight1":
      "Authentic traditional recipes and cooking methods",
    "product.kTraditional.highlight2":
      "Authentic ingredients sourced from Korea",
    "product.kTraditional.highlight3": "Restaurant-quality meals at home",
    "product.kTraditional.content1":
      "Premium ingredients (perfectly portioned for each dish)",
    "product.kTraditional.content2": "Traditional secret seasonings and sauces",
    "product.kTraditional.content3":
      "Step-by-step recipe cards + expert video tutorials",
    "product.kTraditional.content4":
      "Traditional cooking method guides and tips",
  },
};

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguage] = useState<Language>("en");

  const toggleLanguage = () => {
    setLanguage((prev) => (prev === "ko" ? "en" : "ko"));
  };

  const t = (key: string): string => {
    return translations[language][key] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, toggleLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error("useLanguage must be used within a LanguageProvider");
  }
  return context;
}

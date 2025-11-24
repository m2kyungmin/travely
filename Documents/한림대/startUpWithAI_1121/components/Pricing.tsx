"use client";

import { motion } from "framer-motion";
import { Check, Sparkles, Film, Leaf, ChefHat } from "lucide-react";
import Image from "next/image";
import { useState, useEffect } from "react";
import Card from "./ui/Card";
import Button from "./ui/Button";
import Badge from "./ui/Badge";
import { useLanguage } from "@/contexts/LanguageContext";
import SubscribeModal from "./SubscribeModal";
import ProductDetailModal from "./ProductDetailModal";

// Box Image Slider Component
function BoxImageSlider({
  images,
  boxName,
}: {
  images: string[];
  boxName: string;
}) {
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    if (images.length <= 1) return;

    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % images.length);
    }, 3000); // 3초마다 이미지 변경

    return () => clearInterval(interval);
  }, [images.length]);

  return (
    <div className="relative w-full h-48 mb-6 overflow-hidden group">
      <div className="relative w-full h-full">
        {images.map((image, imgIndex) => (
          <motion.div
            key={imgIndex}
            className="absolute inset-0"
            initial={{ opacity: 0 }}
            animate={{
              opacity: imgIndex === currentIndex ? 1 : 0,
            }}
            transition={{ duration: 0.5 }}
          >
            <Image
              src={image}
              alt={`${boxName} box ${imgIndex + 1}`}
              fill
              className="object-cover"
              sizes="(max-width: 768px) 100vw, 33vw"
            />
          </motion.div>
        ))}
      </div>
      {/* Image indicator dots */}
      {images.length > 1 && (
        <div className="absolute bottom-2 left-1/2 transform -translate-x-1/2 flex gap-1.5 z-10">
          {images.map((_, dotIndex) => (
            <button
              key={dotIndex}
              onClick={() => setCurrentIndex(dotIndex)}
              className={`w-2 h-2 rounded-full transition-all ${
                dotIndex === currentIndex
                  ? "bg-white w-6"
                  : "bg-white/60 hover:bg-white/80"
              }`}
              aria-label={`Go to image ${dotIndex + 1}`}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export default function Pricing() {
  const { t } = useLanguage();
  const [selectedTier, setSelectedTier] = useState<{
    boxType: "kCulture" | "kVegan" | "kTraditional";
    boxName: string;
    price: number;
    originalPrice?: number;
    type: "one-time" | "subscription";
  } | null>(null);
  const [selectedDetailBox, setSelectedDetailBox] = useState<{
    boxType: "kCulture" | "kVegan" | "kTraditional";
    boxName: string;
    boxImages: string[];
  } | null>(null);

  const pricingTiers = [
    {
      name: t("pricing.kCulture.name"),
      type: "one-time" as const,
      originalPrice: 39.99,
      discountedPrice: 27.99,
      meals: 2,
      target: t("pricing.kCulture.target"),
      icon: Film,
      color: "obangsaek-yellow",
      boxImages: [
        "/images/boxes/kimchi-jeon.jpeg",
        "/images/boxes/dakgangjeong.jpeg",
        "/images/boxes/tteokbokki.jpeg",
      ],
      features: [
        t("pricing.kCulture.feature1"),
        t("pricing.kCulture.feature2"),
        t("pricing.kCulture.feature3"),
        t("pricing.kCulture.feature4"),
        t("pricing.kCulture.feature5"),
      ],
      popular: false,
      cta: t("pricing.kCulture.cta"),
    },
    {
      name: t("pricing.kVegan.name"),
      type: "subscription" as const,
      price: 44.99,
      pricePerMeal: 22.50,
      mealsPerWeek: 2,
      target: t("pricing.kVegan.target"),
      icon: Leaf,
      color: "green-500",
      boxImages: [
        "/images/boxes/vegan-kimbap.jpeg",
        "/images/boxes/vegan-japchae.jpeg",
        "/images/boxes/vegan-sundubu-jjigae.jpeg",
      ],
      features: [
        t("pricing.kVegan.feature1"),
        t("pricing.kVegan.feature2"),
        t("pricing.kVegan.feature3"),
        t("pricing.kVegan.feature4"),
        t("pricing.kVegan.feature5"),
      ],
      popular: false,
      cta: t("pricing.kVegan.cta"),
    },
    {
      name: t("pricing.kTraditional.name"),
      type: "subscription" as const,
      price: 64.99,
      pricePerMeal: 21.66,
      mealsPerWeek: 3,
      target: t("pricing.kTraditional.target"),
      icon: ChefHat,
      color: "obangsaek-red",
      boxImages: [
        "/images/boxes/bulgogi.jpeg",
        "/images/boxes/bibimbap.jpeg",
        "/images/boxes/galbi-jjim.jpeg",
      ],
      features: [
        t("pricing.kTraditional.feature1"),
        t("pricing.kTraditional.feature2"),
        t("pricing.kTraditional.feature3"),
        t("pricing.kTraditional.feature4"),
        t("pricing.kTraditional.feature5"),
        t("pricing.kTraditional.feature6"),
      ],
      popular: true,
      cta: t("pricing.kTraditional.cta"),
    },
  ];
  const handleSubscribe = (
    boxType: "kCulture" | "kVegan" | "kTraditional",
    boxName: string,
    price: number,
    originalPrice: number | undefined,
    type: "one-time" | "subscription"
  ) => {
    setSelectedTier({ boxType, boxName, price, originalPrice, type });
  };

  return (
    <section id="pricing" className="py-20 bg-bg-primary">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold text-text-primary mb-4">
            {t("pricing.title")}
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto mb-4">
            {t("pricing.subtitle")}
          </p>
          <p className="text-sm text-gray-500 mb-6">
            {t("pricing.boxes")}
          </p>
          <div className="inline-flex items-center gap-2 bg-yellow-50 border-2 border-yellow-200 rounded-full px-6 py-3">
            <Sparkles className="w-5 h-5 text-yellow-600" />
            <span className="font-bold text-yellow-800">
              {t("pricing.promotion")}
            </span>
          </div>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {pricingTiers.map((tier, index) => {
            const Icon = tier.icon;
            return (
              <motion.div
                key={tier.name}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
                className="relative"
              >
                <Card
                  className={`h-full flex flex-col overflow-visible relative ${
                    tier.popular
                      ? "border-2 border-obangsaek-yellow shadow-xl scale-105"
                      : ""
                  }`}
                >
                  {tier.popular && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 z-10">
                      <Badge variant="warning" className="text-sm font-bold">
                        {t("pricing.mostPopular")}
                      </Badge>
                    </div>
                  )}
                  {tier.type === "one-time" && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 z-10">
                      <Badge variant="info" className="text-sm font-bold">
                        {t("pricing.oneTime")}
                      </Badge>
                    </div>
                  )}
                  {/* Box Images Gallery */}
                  <BoxImageSlider images={tier.boxImages} boxName={tier.name} />

                  <div className="mb-6 px-6">
                    <div className="flex items-center gap-3 mb-3">
                      <div
                        className={`w-12 h-12 rounded-full flex items-center justify-center ${
                          tier.color === "obangsaek-yellow"
                            ? "bg-obangsaek-yellow"
                            : tier.color === "obangsaek-red"
                            ? "bg-obangsaek-red"
                            : "bg-obangsaek-green"
                        }`}
                      >
                        <Icon className="w-6 h-6 text-white" />
                      </div>
                      <div>
                        <h3 className="text-2xl font-bold text-text-primary">
                          {tier.name}
                        </h3>
                        <p className="text-sm text-gray-500">{tier.target}</p>
                      </div>
                    </div>
                    {tier.type === "one-time" ? (
                      <div className="mb-4">
                        <div className="flex items-baseline gap-2">
                          <span className="text-2xl text-gray-400 line-through">
                            ${tier.originalPrice}
                          </span>
                          <span className="text-4xl font-bold text-obangsaek-red">
                            ${tier.discountedPrice}
                          </span>
                        </div>
                        <p className="text-sm text-gray-600 mt-1">
                          {tier.meals} {t("pricing.kCulture.meals")}
                        </p>
                      </div>
                    ) : (
                      <div className="mb-4">
                        <div className="flex items-baseline gap-2">
                          <span className="text-4xl font-bold text-obangsaek-red">
                            ${tier.price}
                          </span>
                          <span className="text-gray-500 ml-2">{t("pricing.week")}</span>
                        </div>
                        {tier.pricePerMeal && (
                          <p className="text-sm text-gray-600">
                            ${tier.pricePerMeal.toFixed(2)}{" "}
                            {index === 1
                              ? t("pricing.kVegan.perMeal")
                              : t("pricing.kTraditional.perMeal")}
                          </p>
                        )}
                        {tier.mealsPerWeek && (
                          <p className="text-xs text-gray-500 mt-1">
                            {tier.mealsPerWeek}{" "}
                            {index === 1
                              ? t("pricing.kVegan.perWeek")
                              : t("pricing.kTraditional.perWeek")}
                          </p>
                        )}
                      </div>
                    )}
                  </div>

                  <ul className="flex-1 mb-6 space-y-3 px-6">
                    {tier.features.map((feature, idx) => (
                      <li key={idx} className="flex items-start gap-2">
                        <Check className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                        <span className="text-gray-600">{feature}</span>
                      </li>
                    ))}
                  </ul>

                  <div className="px-6 pb-6 space-y-3">
                    <Button
                      variant="secondary"
                      className="w-full bg-gray-500 text-white hover:bg-gray-600 shadow-md hover:shadow-lg"
                      size="md"
                      onClick={() =>
                        setSelectedDetailBox({
                          boxType:
                            index === 0
                              ? "kCulture"
                              : index === 1
                              ? "kVegan"
                              : "kTraditional",
                          boxName: tier.name,
                          boxImages: tier.boxImages,
                        })
                      }
                    >
                      {t("product.button.learnMore")}
                    </Button>
                    <Button
                      variant="primary"
                      className="w-full bg-obangsaek-red hover:bg-[#8B3428] text-white shadow-md hover:shadow-lg"
                      size="lg"
                      onClick={() =>
                        handleSubscribe(
                          index === 0
                            ? "kCulture"
                            : index === 1
                            ? "kVegan"
                            : "kTraditional",
                          tier.name,
                          tier.type === "one-time"
                            ? tier.discountedPrice
                            : tier.price,
                          tier.type === "one-time"
                            ? tier.originalPrice
                            : undefined,
                          tier.type
                        )
                      }
                    >
                      {tier.cta}
                    </Button>
                  </div>
                </Card>
              </motion.div>
            );
          })}
        </div>
      </div>

      {selectedTier && (
        <SubscribeModal
          isOpen={!!selectedTier}
          onClose={() => setSelectedTier(null)}
          boxType={selectedTier.boxType}
          boxName={selectedTier.boxName}
          price={selectedTier.price}
          originalPrice={selectedTier.originalPrice}
          type={selectedTier.type}
        />
      )}

      {selectedDetailBox && (
        <ProductDetailModal
          isOpen={!!selectedDetailBox}
          onClose={() => setSelectedDetailBox(null)}
          boxType={selectedDetailBox.boxType}
          boxName={selectedDetailBox.boxName}
          boxImages={selectedDetailBox.boxImages}
          onSubscribe={() => {
            setSelectedDetailBox(null);
            // 해당 박스 타입의 구독 모달 열기
            const tierIndex =
              selectedDetailBox.boxType === "kCulture"
                ? 0
                : selectedDetailBox.boxType === "kVegan"
                ? 1
                : 2;
            const tier = pricingTiers[tierIndex];
            handleSubscribe(
              selectedDetailBox.boxType,
              tier.name,
              tier.type === "one-time"
                ? tier.discountedPrice
                : tier.price,
              tier.type === "one-time" ? tier.originalPrice : undefined,
              tier.type
            );
          }}
        />
      )}
    </section>
  );
}


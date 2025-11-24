"use client";

import { motion } from "framer-motion";
import { X, Info, Package, Heart, Sparkles } from "lucide-react";
import Image from "next/image";
import Modal from "./ui/Modal";
import Button from "./ui/Button";
import { useLanguage } from "@/contexts/LanguageContext";

interface ProductDetailModalProps {
  isOpen: boolean;
  onClose: () => void;
  boxType: "kCulture" | "kVegan" | "kTraditional";
  boxName: string;
  boxImages: string[];
  onSubscribe: () => void;
}

export default function ProductDetailModal({
  isOpen,
  onClose,
  boxType,
  boxName,
  boxImages,
  onSubscribe,
}: ProductDetailModalProps) {
  const { t } = useLanguage();

  // 각 박스 타입별 상세 정보
  const boxDetails = {
    kCulture: {
      meals: [
        {
          nameKo: "김치전",
          nameEn: "Kimchi Jeon",
          description: t("product.kCulture.meal1.description"),
          image: "/images/boxes/kimchi-jeon.jpeg",
        },
        {
          nameKo: "닭강정",
          nameEn: "Dakgangjeong",
          description: t("product.kCulture.meal2.description"),
          image: "/images/boxes/dakgangjeong.jpeg",
        },
        {
          nameKo: "떡볶이",
          nameEn: "Tteokbokki",
          description: t("product.kCulture.meal3.description"),
          image: "/images/boxes/tteokbokki.jpeg",
        },
      ],
      highlights: [
        t("product.kCulture.highlight1"),
        t("product.kCulture.highlight2"),
        t("product.kCulture.highlight3"),
      ],
      contents: [
        t("product.kCulture.content1"),
        t("product.kCulture.content2"),
        t("product.kCulture.content3"),
        t("product.kCulture.content4"),
      ],
    },
    kVegan: {
      meals: [
        {
          nameKo: "비건 김밥",
          nameEn: "Vegan Kimbap",
          description: t("product.kVegan.meal1.description"),
          image: "/images/boxes/vegan-kimbap.jpeg",
        },
        {
          nameKo: "비건 잡채",
          nameEn: "Vegan Japchae",
          description: t("product.kVegan.meal2.description"),
          image: "/images/boxes/vegan-japchae.jpeg",
        },
        {
          nameKo: "비건 순두부찌개",
          nameEn: "Vegan Sundubu Jjigae",
          description: t("product.kVegan.meal3.description"),
          image: "/images/boxes/vegan-sundubu-jjigae.jpeg",
        },
      ],
      highlights: [
        t("product.kVegan.highlight1"),
        t("product.kVegan.highlight2"),
        t("product.kVegan.highlight3"),
      ],
      contents: [
        t("product.kVegan.content1"),
        t("product.kVegan.content2"),
        t("product.kVegan.content3"),
        t("product.kVegan.content4"),
      ],
    },
    kTraditional: {
      meals: [
        {
          nameKo: "불고기",
          nameEn: "Bulgogi",
          description: t("product.kTraditional.meal1.description"),
          image: "/images/boxes/bulgogi.jpeg",
        },
        {
          nameKo: "비빔밥",
          nameEn: "Bibimbap",
          description: t("product.kTraditional.meal2.description"),
          image: "/images/boxes/bibimbap.jpeg",
        },
        {
          nameKo: "갈비찜",
          nameEn: "Galbi Jjim",
          description: t("product.kTraditional.meal3.description"),
          image: "/images/boxes/galbi-jjim.jpeg",
        },
      ],
      highlights: [
        t("product.kTraditional.highlight1"),
        t("product.kTraditional.highlight2"),
        t("product.kTraditional.highlight3"),
      ],
      contents: [
        t("product.kTraditional.content1"),
        t("product.kTraditional.content2"),
        t("product.kTraditional.content3"),
        t("product.kTraditional.content4"),
      ],
    },
  };

  const details = boxDetails[boxType];

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={boxName} size="xl">
      <div className="p-6">
        {/* Box Images Gallery */}
        <div className="mb-8">
          <div className="grid grid-cols-3 gap-2 mb-4">
            {boxImages.map((image, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: index * 0.1 }}
                className="relative aspect-square rounded-lg overflow-hidden"
              >
                <Image
                  src={image}
                  alt={`${boxName} box ${index + 1}`}
                  fill
                  className="object-cover"
                  sizes="(max-width: 768px) 33vw, 200px"
                />
              </motion.div>
            ))}
          </div>
        </div>

        {/* Included Meals */}
        <div className="mb-8">
          <h3 className="text-xl font-bold text-text-primary mb-4 flex items-center gap-2">
            <Package className="w-5 h-5 text-obangsaek-red" />
            {t("product.includedMeals")}
          </h3>
          <div className="space-y-4">
            {details.meals.map((meal, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.1 }}
                className="flex gap-4 p-4 bg-gray-50 rounded-lg"
              >
                <div className="relative w-24 h-24 flex-shrink-0 rounded-lg overflow-hidden">
                  <Image
                    src={meal.image}
                    alt={meal.nameEn}
                    fill
                    className="object-cover"
                    sizes="96px"
                  />
                </div>
                <div className="flex-1">
                  <h4 className="font-bold text-text-primary mb-1">
                    {meal.nameKo} ({meal.nameEn})
                  </h4>
                  <p className="text-sm text-gray-600">{meal.description}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Highlights */}
        <div className="mb-8">
          <h3 className="text-xl font-bold text-text-primary mb-4 flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-obangsaek-yellow" />
            {t("product.highlights")}
          </h3>
          <ul className="space-y-2">
            {details.highlights.map((highlight, index) => (
              <li key={index} className="flex items-start gap-2">
                <Heart className="w-5 h-5 text-obangsaek-red flex-shrink-0 mt-0.5" />
                <span className="text-gray-700">{highlight}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* What's Inside */}
        <div className="mb-8">
          <h3 className="text-xl font-bold text-text-primary mb-4 flex items-center gap-2">
            <Info className="w-5 h-5 text-blue-600" />
            {t("product.whatsInside")}
          </h3>
          <ul className="space-y-2">
            {details.contents.map((content, index) => (
              <li key={index} className="flex items-start gap-2">
                <div className="w-2 h-2 rounded-full bg-obangsaek-red mt-2 flex-shrink-0" />
                <span className="text-gray-700">{content}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* CTA Buttons */}
        <div className="flex gap-4 pt-6 border-t">
          <Button variant="outline" onClick={onClose} className="flex-1">
            {t("product.button.close")}
          </Button>
          <Button variant="primary" onClick={onSubscribe} className="flex-1">
            {t("product.button.subscribe")}
          </Button>
        </div>
      </div>
    </Modal>
  );
}


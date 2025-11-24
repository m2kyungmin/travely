"use client";

import { motion } from "framer-motion";
import { Clock } from "lucide-react";
import Image from "next/image";
import Card from "./ui/Card";
import Badge from "./ui/Badge";
import { mealKits } from "@/data/mealkits";
import { MealKit } from "@/types";

const difficultyColors = {
  easy: "success",
  medium: "warning",
  hard: "default",
} as const;

export default function ProductCarousel() {
  return (
    <section className="py-20 bg-gradient-to-b from-white to-primary-cream">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold text-primary-charcoal mb-4">
            Our Signature Dishes
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Discover authentic Korean flavors, one meal kit at a time
          </p>
        </motion.div>

        <div className="overflow-x-auto pb-8 -mx-4 px-4">
          <div className="flex gap-6 min-w-max">
            {mealKits.map((kit: MealKit, index: number) => (
              <motion.div
                key={kit.id}
                initial={{ opacity: 0, x: 50 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
                className="w-80 flex-shrink-0"
              >
                <Card className="h-full overflow-hidden">
                  <div className="relative w-full h-48 mb-4 rounded-lg overflow-hidden">
                    <Image
                      src={kit.image}
                      alt={kit.nameEn}
                      fill
                      className="object-cover"
                      sizes="(max-width: 320px) 100vw, 320px"
                    />
                  </div>
                  <div className="mb-3">
                    <h3 className="text-xl font-bold text-primary-charcoal mb-1">
                      {kit.nameKo}
                    </h3>
                    <p className="text-gray-600 text-sm">{kit.nameEn}</p>
                  </div>
                  <p className="text-gray-500 text-sm mb-4 line-clamp-2">
                    {kit.story}
                  </p>
                  <div className="flex items-center gap-3 mb-4 flex-wrap">
                    <Badge variant={difficultyColors[kit.difficulty]}>
                      {kit.difficulty}
                    </Badge>
                    <div className="flex items-center gap-1 text-gray-600 text-sm">
                      <Clock className="w-4 h-4" />
                      <span>{kit.cookingTime} min</span>
                    </div>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-2xl font-bold text-primary-red">
                      ${kit.price}
                    </span>
                    <button className="text-primary-orange hover:text-primary-red font-semibold transition-colors">
                      Add to Box →
                    </button>
                  </div>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ delay: 0.5, duration: 0.6 }}
          className="text-center mt-8"
        >
          <p className="text-gray-600 mb-4">
            Scroll horizontally to see more dishes
          </p>
          <button className="text-primary-red font-semibold hover:underline">
            View All Menu →
          </button>
        </motion.div>
      </div>
    </section>
  );
}


"use client";

import { motion } from "framer-motion";
import { ShoppingBag, ChefHat, BookOpen } from "lucide-react";
import Card from "./ui/Card";

const painPoints = [
  {
    icon: ShoppingBag,
    title: "Hard to Find Ingredients?",
    problem: "Korean ingredients are hard to find locally",
    solution:
      "All authentic Korean ingredients delivered, specially packaged for freshness",
    color: "text-obangsaek-red",
  },
  {
    icon: ChefHat,
    title: "Struggling with Authentic Taste?",
    problem: "Can't recreate restaurant-quality Korean food",
    solution:
      "Pre-measured secret sauces and traditional seasonings included",
    color: "text-obangsaek-yellow",
  },
  {
    icon: BookOpen,
    title: "Complicated Recipes?",
    problem: "Complex cooking steps lead to failures",
    solution:
      "Step-by-step visual guides + QR-linked video tutorials",
    color: "text-obangsaek-red",
  },
];

export default function PainPoints() {
  return (
    <section className="py-20 bg-bg-secondary korean-pattern" style={{ backgroundColor: '#F5F3EF' }}>
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold text-text-primary mb-4">
            We Understand Your Challenges
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Cooking authentic Korean food shouldn't be complicated
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {painPoints.map((point, index) => {
            const Icon = point.icon;
            return (
              <motion.div
                key={point.title}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.2, duration: 0.6 }}
              >
                <Card className="h-full flex flex-col">
                  <div className={`${point.color} mb-4`}>
                    <Icon className="w-12 h-12" />
                  </div>
                  <h3 className="text-xl font-bold text-text-primary mb-3">
                    {point.title}
                  </h3>
                  <div className="mb-4">
                    <p className="text-gray-600 font-medium mb-2">
                      Problem:
                    </p>
                    <p className="text-gray-500">{point.problem}</p>
                  </div>
                  <div className="mt-auto">
                    <p className="text-gray-600 font-medium mb-2">
                      Solution:
                    </p>
                    <p className="text-text-primary font-semibold">
                      {point.solution}
                    </p>
                  </div>
                </Card>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}


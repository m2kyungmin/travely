"use client";

import { motion } from "framer-motion";
import { Calendar, Truck, ChefHat } from "lucide-react";
import Card from "./ui/Card";

const steps = [
  {
    icon: Calendar,
    title: "Choose Your Meals",
    description:
      "Browse our menu and select your favorite Korean dishes. Customize your box based on your preferences.",
    step: "01",
  },
  {
    icon: Truck,
    title: "Receive Your Kit",
    description:
      "Get fresh, pre-portioned ingredients delivered to your door. Everything you need is included.",
    step: "02",
  },
  {
    icon: ChefHat,
    title: "Cook & Enjoy",
    description:
      "Follow our easy step-by-step guides and video tutorials. Create restaurant-quality meals in minutes.",
    step: "03",
  },
];

export default function HowItWorks() {
  return (
    <section className="py-20 bg-bg-primary">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold text-text-primary mb-4">
            How It Works
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Three simple steps to authentic Korean flavors
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
          {steps.map((step, index) => {
            const Icon = step.icon;
            return (
              <motion.div
                key={step.step}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.2, duration: 0.6 }}
                className="relative"
              >
                <Card className="h-full text-center relative">
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <div className="w-12 h-12 bg-obangsaek-red text-white rounded-full flex items-center justify-center font-bold text-lg shadow-lg">
                      {step.step}
                    </div>
                  </div>
                  <div className="mt-8 mb-6 flex justify-center">
                    <div className="w-20 h-20 bg-bg-secondary rounded-full flex items-center justify-center">
                      <Icon className="w-10 h-10 text-obangsaek-red" />
                    </div>
                  </div>
                  <h3 className="text-xl font-bold text-text-primary mb-3">
                    {step.title}
                  </h3>
                  <p className="text-gray-600">{step.description}</p>
                </Card>
                {index < steps.length - 1 && (
                  <div className="hidden md:block absolute top-1/2 -right-4 transform -translate-y-1/2 z-10">
                    <div className="w-8 h-0.5 bg-obangsaek-yellow" />
                    <div className="absolute right-0 top-1/2 transform -translate-y-1/2 w-0 h-0 border-l-8 border-l-obangsaek-yellow border-t-4 border-t-transparent border-b-4 border-b-transparent" />
                  </div>
                )}
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}


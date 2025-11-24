"use client";

import { motion } from "framer-motion";
import { Film, Heart, Users, Clock } from "lucide-react";
import Card from "./ui/Card";

const benefits = [
  {
    icon: Film,
    title: "Cultural Experience",
    description:
      "Storytelling cards with each meal. K-drama/K-movie themed special editions.",
    color: "bg-obangsaek-red",
  },
  {
    icon: Heart,
    title: "Healthy & Natural",
    description:
      "GMO-free, low-sodium options. Traditional Korean nutritional balance.",
    color: "bg-green-500",
  },
  {
    icon: Users,
    title: "Share Your Journey",
    description:
      "SNS hashtag campaigns (#MyKfoodMoment). Subscriber community access.",
    color: "bg-obangsaek-yellow",
  },
  {
    icon: Clock,
    title: "Save Time",
    description: "15-30 minute recipes. Pre-prepped ingredients.",
    color: "bg-blue-500",
  },
];

export default function Benefits() {
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
            Why Choose Cook-K?
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            More than just a meal - it's a journey into Korean culture
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {benefits.map((benefit, index) => {
            const Icon = benefit.icon;
            return (
              <motion.div
                key={benefit.title}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
              >
                <Card className="h-full text-center">
                  <div
                    className={`${benefit.color} w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4`}
                  >
                    <Icon className="w-8 h-8 text-white" />
                  </div>
                  <h3 className="text-xl font-bold text-text-primary mb-3">
                    {benefit.title}
                  </h3>
                  <p className="text-gray-600">{benefit.description}</p>
                </Card>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

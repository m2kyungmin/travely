"use client";

import { useLanguage } from "@/contexts/LanguageContext";
import { motion } from "framer-motion";

export default function LanguageToggle() {
  const { language, toggleLanguage } = useLanguage();

  return (
    <div className="fixed top-4 right-4 z-50">
      <motion.button
        onClick={toggleLanguage}
        className="flex items-center gap-2 bg-white/90 backdrop-blur-sm border-2 border-obangsaek-red rounded-full px-4 py-2 shadow-lg hover:bg-white transition-colors"
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
      >
        <span
          className={`font-bold transition-colors ${
            language === "ko" ? "text-obangsaek-red" : "text-gray-400"
          }`}
        >
          한
        </span>
        <div
          className={`w-10 h-6 rounded-full relative transition-colors ${
            language === "ko" ? "bg-obangsaek-red" : "bg-gray-300"
          }`}
        >
          <motion.div
            className="absolute top-1 w-4 h-4 bg-white rounded-full shadow-md"
            animate={{
              x: language === "ko" ? 0 : 16,
            }}
            transition={{ type: "spring", stiffness: 500, damping: 30 }}
          />
        </div>
        <span
          className={`font-bold transition-colors ${
            language === "en" ? "text-obangsaek-red" : "text-gray-400"
          }`}
        >
          EN
        </span>
      </motion.button>
    </div>
  );
}

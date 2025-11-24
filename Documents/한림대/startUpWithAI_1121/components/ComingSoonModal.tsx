"use client";

import { motion } from "framer-motion";
import { Clock } from "lucide-react";
import Modal from "./ui/Modal";
import Button from "./ui/Button";
import { useLanguage } from "@/contexts/LanguageContext";

interface ComingSoonModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function ComingSoonModal({
  isOpen,
  onClose,
}: ComingSoonModalProps) {
  const { t } = useLanguage();

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={t("comingSoon.title")}>
      <div className="p-8 text-center">
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ type: "spring", stiffness: 200, damping: 15 }}
          className="w-20 h-20 bg-obangsaek-yellow rounded-full flex items-center justify-center mx-auto mb-6"
        >
          <Clock className="w-10 h-10 text-white" />
        </motion.div>
        <h3 className="text-2xl font-bold text-text-primary mb-4">
          {t("comingSoon.title")}
        </h3>
        <p className="text-gray-600 mb-8">{t("comingSoon.message")}</p>
        <Button variant="primary" onClick={onClose}>
          {t("modal.button.close")}
        </Button>
      </div>
    </Modal>
  );
}

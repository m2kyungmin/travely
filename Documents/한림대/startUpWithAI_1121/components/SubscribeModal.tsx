"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Check, CreditCard, Calendar, Truck } from "lucide-react";
import Modal from "./ui/Modal";
import Button from "./ui/Button";
import { useLanguage } from "@/contexts/LanguageContext";

interface SubscribeModalProps {
  isOpen: boolean;
  onClose: () => void;
  boxType: "kCulture" | "kVegan" | "kTraditional";
  boxName: string;
  price: number;
  originalPrice?: number;
  type: "one-time" | "subscription";
}

type Step = "info" | "payment" | "confirmation";

export default function SubscribeModal({
  isOpen,
  onClose,
  boxType,
  boxName,
  price,
  originalPrice,
  type,
}: SubscribeModalProps) {
  const { t } = useLanguage();
  const [currentStep, setCurrentStep] = useState<Step>("info");
  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    address: "",
    city: "",
    state: "",
    zip: "",
    deliveryDate: "",
    frequency: type === "subscription" ? "weekly" : "",
    paymentMethod: "card",
    cardNumber: "",
    cardName: "",
    expiryDate: "",
    cvv: "",
  });

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    let value = e.target.value;

    // 카드 번호 포맷팅
    if (e.target.name === "cardNumber") {
      value = value
        .replace(/\s/g, "")
        .replace(/(.{4})/g, "$1 ")
        .trim();
      if (value.length > 19) value = value.slice(0, 19);
    }

    // 만료일 포맷팅 (MM/YY)
    if (e.target.name === "expiryDate") {
      value = value.replace(/\D/g, "");
      if (value.length >= 2) {
        value = value.slice(0, 2) + "/" + value.slice(2, 4);
      }
      if (value.length > 5) value = value.slice(0, 5);
    }

    // CVV는 숫자만
    if (e.target.name === "cvv") {
      value = value.replace(/\D/g, "").slice(0, 3);
    }

    setFormData({
      ...formData,
      [e.target.name]: value,
    });
  };

  const handleNext = () => {
    if (currentStep === "info") {
      // 간단한 유효성 검사
      if (
        formData.firstName &&
        formData.lastName &&
        formData.email &&
        formData.phone &&
        formData.address
      ) {
        setCurrentStep("payment");
      }
    } else if (currentStep === "payment") {
      // 가상 결제 처리
      setTimeout(() => {
        setCurrentStep("confirmation");
      }, 1500);
    }
  };

  const handleSubmit = () => {
    // 가상 결제 완료 처리
    handleNext();
  };

  const resetModal = () => {
    setCurrentStep("info");
    setFormData({
      firstName: "",
      lastName: "",
      email: "",
      phone: "",
      address: "",
      city: "",
      state: "",
      zip: "",
      deliveryDate: "",
      frequency: type === "subscription" ? "weekly" : "",
      paymentMethod: "card",
      cardNumber: "",
      cardName: "",
      expiryDate: "",
      cvv: "",
    });
  };

  const handleClose = () => {
    resetModal();
    onClose();
  };

  const steps = [
    { id: "info", label: t("modal.step.info"), icon: Truck },
    { id: "payment", label: t("modal.step.payment"), icon: CreditCard },
    { id: "confirmation", label: t("modal.step.confirmation"), icon: Check },
  ];

  return (
    <Modal isOpen={isOpen} onClose={handleClose} title={boxName} size="lg">
      <div className="p-6">
        {/* Step Indicator */}
        <div className="flex items-center justify-between mb-8">
          {steps.map((step, index) => {
            const Icon = step.icon;
            const isActive =
              steps.findIndex((s) => s.id === currentStep) >= index;
            return (
              <div key={step.id} className="flex items-center flex-1">
                <div className="flex flex-col items-center flex-1">
                  <div
                    className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${
                      isActive
                        ? "bg-obangsaek-red text-white"
                        : "bg-gray-200 text-gray-500"
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                  </div>
                  <span
                    className={`text-xs mt-2 ${
                      isActive
                        ? "text-obangsaek-red font-semibold"
                        : "text-gray-500"
                    }`}
                  >
                    {step.label}
                  </span>
                </div>
                {index < steps.length - 1 && (
                  <div
                    className={`h-1 flex-1 mx-2 transition-colors ${
                      isActive ? "bg-obangsaek-red" : "bg-gray-200"
                    }`}
                  />
                )}
              </div>
            );
          })}
        </div>

        {/* Step 1: Information */}
        {currentStep === "info" && (
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            className="space-y-6"
          >
            <div>
              <h3 className="text-xl font-bold text-text-primary mb-4">
                {t("modal.info.title")}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.firstName")}
                  </label>
                  <input
                    type="text"
                    name="firstName"
                    value={formData.firstName}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.lastName")}
                  </label>
                  <input
                    type="text"
                    name="lastName"
                    value={formData.lastName}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.email")}
                  </label>
                  <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.phone")}
                  </label>
                  <input
                    type="tel"
                    name="phone"
                    value={formData.phone}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.address")}
                  </label>
                  <input
                    type="text"
                    name="address"
                    value={formData.address}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.city")}
                  </label>
                  <input
                    type="text"
                    name="city"
                    value={formData.city}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.state")}
                  </label>
                  <input
                    type="text"
                    name="state"
                    value={formData.state}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.info.zip")}
                  </label>
                  <input
                    type="text"
                    name="zip"
                    value={formData.zip}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
                {type === "subscription" && (
                  <div className="md:col-span-2">
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t("modal.info.frequency")}
                    </label>
                    <select
                      name="frequency"
                      value={formData.frequency}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    >
                      <option value="weekly">{t("modal.info.weekly")}</option>
                      <option value="biweekly">
                        {t("modal.info.biweekly")}
                      </option>
                      <option value="monthly">{t("modal.info.monthly")}</option>
                    </select>
                  </div>
                )}
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    <Calendar className="w-4 h-4 inline mr-2" />
                    {t("modal.info.deliveryDate")}
                  </label>
                  <input
                    type="date"
                    name="deliveryDate"
                    value={formData.deliveryDate}
                    onChange={handleInputChange}
                    min={new Date().toISOString().split("T")[0]}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    required
                  />
                </div>
              </div>
            </div>
            <div className="flex justify-end gap-4 pt-4 border-t">
              <Button variant="outline" onClick={handleClose}>
                {t("modal.button.cancel")}
              </Button>
              <Button variant="primary" onClick={handleNext}>
                {t("modal.button.next")}
              </Button>
            </div>
          </motion.div>
        )}

        {/* Step 2: Payment */}
        {currentStep === "payment" && (
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            className="space-y-6"
          >
            <div>
              <h3 className="text-xl font-bold text-text-primary mb-4">
                {t("modal.payment.title")}
              </h3>
              <div className="bg-bg-secondary p-4 rounded-lg mb-6">
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">{boxName}</span>
                  <div className="text-right">
                    {originalPrice && (
                      <span className="text-gray-400 line-through mr-2">
                        ${originalPrice}
                      </span>
                    )}
                    <span className="text-2xl font-bold text-obangsaek-red">
                      ${price}
                    </span>
                  </div>
                </div>
                {type === "subscription" && (
                  <p className="text-sm text-gray-600 mt-2">
                    {t("modal.payment.subscriptionNote")}
                  </p>
                )}
              </div>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.payment.cardNumber")}
                  </label>
                  <input
                    type="text"
                    name="cardNumber"
                    value={formData.cardNumber}
                    onChange={handleInputChange}
                    placeholder="1234 5678 9012 3456"
                    maxLength={19}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {t("modal.payment.cardName")}
                  </label>
                  <input
                    type="text"
                    name="cardName"
                    value={formData.cardName}
                    onChange={handleInputChange}
                    placeholder="John Doe"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t("modal.payment.expiryDate")}
                    </label>
                    <input
                      type="text"
                      name="expiryDate"
                      value={formData.expiryDate}
                      onChange={handleInputChange}
                      placeholder="MM/YY"
                      maxLength={5}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      {t("modal.payment.cvv")}
                    </label>
                    <input
                      type="text"
                      name="cvv"
                      value={formData.cvv}
                      onChange={handleInputChange}
                      placeholder="123"
                      maxLength={3}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-obangsaek-red focus:border-transparent"
                    />
                  </div>
                </div>
                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                  <p className="text-sm text-yellow-800">
                    {t("modal.payment.demoNote")}
                  </p>
                </div>
              </div>
            </div>
            <div className="flex justify-end gap-4 pt-4 border-t">
              <Button variant="outline" onClick={() => setCurrentStep("info")}>
                {t("modal.button.back")}
              </Button>
              <Button variant="primary" onClick={handleSubmit}>
                {t("modal.button.pay")}
              </Button>
            </div>
          </motion.div>
        )}

        {/* Step 3: Confirmation */}
        {currentStep === "confirmation" && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="text-center py-8"
          >
            <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <Check className="w-10 h-10 text-green-600" />
            </div>
            <h3 className="text-2xl font-bold text-text-primary mb-4">
              {t("modal.confirmation.title")}
            </h3>
            <p className="text-gray-600 mb-6">
              {t("modal.confirmation.message")}
            </p>
            <div className="bg-gray-50 rounded-lg p-4 mb-6">
              <p className="text-sm text-gray-600">
                {t("modal.confirmation.emailNote")}
              </p>
            </div>
            <Button variant="primary" onClick={handleClose} className="w-full">
              {t("modal.button.close")}
            </Button>
          </motion.div>
        )}
      </div>
    </Modal>
  );
}

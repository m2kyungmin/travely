import { ReactNode } from "react";
import { motion } from "framer-motion";

interface CardProps {
  children: ReactNode;
  className?: string;
  hover?: boolean;
}

export default function Card({
  children,
  className = "",
  hover = true,
}: CardProps) {
  const baseStyles =
    "bg-bg-card rounded-lg border border-border-light shadow-md hover:shadow-lg transition-all duration-300 p-6";

  return (
    <motion.div
      whileHover={hover ? { y: -8, shadow: "0 20px 25px -5px rgba(0, 0, 0, 0.1)" } : {}}
      className={`${baseStyles} ${className}`}
    >
      {children}
    </motion.div>
  );
}


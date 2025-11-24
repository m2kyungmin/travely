import { ButtonHTMLAttributes, ReactNode } from "react";
import { motion, HTMLMotionProps } from "framer-motion";

interface ButtonProps extends Omit<HTMLMotionProps<"button">, "children"> {
  children: ReactNode;
  variant?: "primary" | "secondary" | "outline";
  size?: "sm" | "md" | "lg";
}

export default function Button({
  children,
  variant = "primary",
  size = "md",
  className = "",
  ...props
}: ButtonProps) {
  const baseStyles =
    "font-semibold rounded-lg transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2";

  const variants = {
    primary:
      "bg-obangsaek-red text-white hover:bg-[#A03D31] focus:ring-obangsaek-red shadow-md hover:shadow-lg transition-all",
    secondary:
      "bg-obangsaek-blue text-white hover:bg-[#1F3A5C] focus:ring-obangsaek-blue shadow-md hover:shadow-lg transition-all",
    outline:
      "border-1.5 border-obangsaek-blue text-obangsaek-blue hover:bg-obangsaek-blue hover:text-white focus:ring-obangsaek-blue transition-all",
  };

  const sizes = {
    sm: "px-4 py-2 text-sm",
    md: "px-6 py-3 text-base",
    lg: "px-8 py-4 text-lg",
  };

  return (
    <motion.button
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${className}`}
      {...(props as any)}
    >
      {children}
    </motion.button>
  );
}

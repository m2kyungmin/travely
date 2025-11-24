import { ReactNode } from "react";

interface BadgeProps {
  children: ReactNode;
  variant?: "default" | "success" | "warning" | "info";
  className?: string;
}

export default function Badge({
  children,
  variant = "default",
  className = "",
}: BadgeProps) {
  const baseStyles = "inline-flex items-center px-3 py-1 rounded-full text-sm font-medium";
  
  const variants = {
    default: "bg-obangsaek-red text-white",
    success: "bg-[rgba(91,138,114,0.1)] text-obangsaek-green",
    warning: "bg-[rgba(201,168,108,0.15)] text-[#8B7340]",
    info: "bg-[rgba(43,75,124,0.1)] text-obangsaek-blue",
  };

  return (
    <span className={`${baseStyles} ${variants[variant]} ${className}`}>
      {children}
    </span>
  );
}


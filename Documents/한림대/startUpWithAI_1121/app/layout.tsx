import type { Metadata } from "next";
import "./globals.css";
import { LanguageProvider } from "@/contexts/LanguageContext";
import LanguageToggle from "@/components/LanguageToggle";

export const metadata: Metadata = {
  title: "Cook-K | Authentic Korean Flavors Delivered",
  description:
    "Experience the taste of Korea with perfectly portioned ingredients and easy-to-follow recipes. Cook authentic Korean dishes at home in 15-30 minutes.",
  keywords: [
    "Korean food",
    "meal kit",
    "Cook-K",
    "Korean recipes",
    "Bibimbap",
    "Bulgogi",
    "Korean cooking",
  ],
  openGraph: {
    title: "Cook-K | Authentic Korean Flavors Delivered",
    description:
      "Experience the taste of Korea with perfectly portioned ingredients and easy-to-follow recipes.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <LanguageProvider>
          <LanguageToggle />
          {children}
        </LanguageProvider>
      </body>
    </html>
  );
}


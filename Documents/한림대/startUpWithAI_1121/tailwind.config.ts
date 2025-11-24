import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        // 오방색 (Obangsaek) - Five Cardinal Colors
        obangsaek: {
          blue: "#1E3A5A", // 청색 - Deeper blue for better contrast
          red: "#A03D31", // 적색 - Darker terracotta red
          yellow: "#B8945A", // 황색 - Richer golden ochre
          black: "#2D2D2D", // 흑색 - Darker charcoal
          green: "#4A7A62", // 청록 - Deeper sage green
        },
        // Background & Neutral Colors
        bg: {
          primary: "#FFFFFF", // Pure white for main sections
          secondary: "#F5F3EF", // Warm light beige (slightly darker for contrast)
          card: "#FFFFFF", // Pure white for cards
        },
        // Text Colors
        text: {
          primary: "#2D2D2D", // Dark charcoal for body text
          secondary: "#6B6B6B", // Medium gray for secondary text
        },
        // Border Colors
        border: {
          light: "#E5E2DC", // Subtle warm border
          medium: "#D1CCC3", // Medium border
        },
        // Legacy primary colors (for backward compatibility)
        primary: {
          red: "#A03D31", // Updated to obangsaek-red
          orange: "#B8945A", // Updated to obangsaek-yellow
          cream: "#F5F3EF", // Updated to bg-secondary
          charcoal: "#2D2D2D", // Updated to obangsaek-black
        },
      },
      fontFamily: {
        sans: ["var(--font-sans)", "system-ui", "sans-serif"],
        heading: [
          "var(--font-heading)",
          "var(--font-sans)",
          "system-ui",
          "sans-serif",
        ],
        body: ["var(--font-body)", "var(--font-sans)", "sans-serif"],
        display: ["var(--font-display)", "serif"],
      },
      borderRadius: {
        sm: "4px",
        md: "8px",
        lg: "12px",
        xl: "20px",
      },
      boxShadow: {
        sm: "0 1px 3px rgba(0, 0, 0, 0.08)",
        md: "0 4px 12px rgba(0, 0, 0, 0.08)",
        lg: "0 8px 24px rgba(0, 0, 0, 0.12)",
      },
    },
  },
  plugins: [],
};
export default config;

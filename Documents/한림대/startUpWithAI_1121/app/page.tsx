import Hero from "@/components/Hero";
import PainPoints from "@/components/PainPoints";
import Benefits from "@/components/Benefits";
import HowItWorks from "@/components/HowItWorks";
import Pricing from "@/components/Pricing";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <main className="min-h-screen">
      <Hero />
      <PainPoints />
      <Benefits />
      <HowItWorks />
      <Pricing />
      <Footer />
    </main>
  );
}


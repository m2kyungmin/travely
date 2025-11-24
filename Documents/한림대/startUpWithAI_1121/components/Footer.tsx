"use client";

import { motion } from "framer-motion";
import {
  Facebook,
  Instagram,
  Twitter,
  Youtube,
  Mail,
  Globe,
} from "lucide-react";
import Link from "next/link";

const footerLinks = {
  company: [
    { name: "About Us", href: "#" },
    { name: "Our Story", href: "#" },
    { name: "Careers", href: "#" },
    { name: "Press", href: "#" },
  ],
  support: [
    { name: "Help Center", href: "#" },
    { name: "Contact Us", href: "#" },
    { name: "Shipping Info", href: "#" },
    { name: "Returns", href: "#" },
  ],
  legal: [
    { name: "Privacy Policy", href: "#" },
    { name: "Terms of Service", href: "#" },
    { name: "Cookie Policy", href: "#" },
  ],
};

const socialLinks = [
  { icon: Facebook, href: "#", label: "Facebook" },
  { icon: Instagram, href: "#", label: "Instagram" },
  { icon: Twitter, href: "#", label: "Twitter" },
  { icon: Youtube, href: "#", label: "YouTube" },
];

const languages = ["EN", "KR", "JP", "CN"];

export default function Footer() {
  return (
    <footer className="bg-obangsaek-black text-white">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8 mb-8">
          {/* Brand Section */}
          <div className="lg:col-span-2">
            <h3 className="text-2xl font-bold mb-4">Cook-K</h3>
            <p className="text-gray-400 mb-6 max-w-md">
              Bringing authentic Korean flavors to your kitchen. Experience the
              taste of Korea with perfectly portioned ingredients and
              easy-to-follow recipes.
            </p>
            <div className="flex gap-4">
              {socialLinks.map((social) => {
                const Icon = social.icon;
                return (
                  <a
                    key={social.label}
                    href={social.href}
                    aria-label={social.label}
                    className="w-10 h-10 rounded-full bg-white/10 hover:bg-obangsaek-red transition-colors flex items-center justify-center"
                  >
                    <Icon className="w-5 h-5" />
                  </a>
                );
              })}
            </div>
          </div>

          {/* Company Links */}
          <div>
            <h4 className="font-semibold mb-4">Company</h4>
            <ul className="space-y-2">
              {footerLinks.company.map((link) => (
                <li key={link.name}>
                  <Link
                    href={link.href}
                    className="text-gray-400 hover:text-white transition-colors"
                  >
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Support Links */}
          <div>
            <h4 className="font-semibold mb-4">Support</h4>
            <ul className="space-y-2">
              {footerLinks.support.map((link) => (
                <li key={link.name}>
                  <Link
                    href={link.href}
                    className="text-gray-400 hover:text-white transition-colors"
                  >
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Legal Links */}
          <div>
            <h4 className="font-semibold mb-4">Legal</h4>
            <ul className="space-y-2">
              {footerLinks.legal.map((link) => (
                <li key={link.name}>
                  <Link
                    href={link.href}
                    className="text-gray-400 hover:text-white transition-colors"
                  >
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Newsletter Signup */}
        <div className="border-t border-gray-700 pt-8 mb-8">
          <div className="max-w-md">
            <h4 className="font-semibold mb-4 flex items-center gap-2">
              <Mail className="w-5 h-5" />
              Subscribe to Our Newsletter
            </h4>
            <p className="text-gray-400 text-sm mb-4">
              Get exclusive recipes, cooking tips, and special offers delivered
              to your inbox.
            </p>
            <form className="flex gap-2">
              <input
                type="email"
                placeholder="Enter your email"
                className="flex-1 px-4 py-2 rounded-lg bg-white/10 border border-white/20 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-obangsaek-red"
              />
              <button
                type="submit"
                className="px-6 py-2 bg-obangsaek-red hover:bg-[#A03D31] rounded-lg font-semibold transition-colors"
              >
                Subscribe
              </button>
            </form>
          </div>
        </div>

        {/* Language Selector & Copyright */}
        <div className="border-t border-gray-700 pt-8 flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="flex items-center gap-4">
            <Globe className="w-5 h-5 text-gray-400" />
            <div className="flex gap-2">
              {languages.map((lang) => (
                <button
                  key={lang}
                  className={`px-3 py-1 rounded text-sm transition-colors ${
                    lang === "EN"
                      ? "bg-obangsaek-red text-white"
                      : "text-gray-400 hover:text-white hover:bg-white/10"
                  }`}
                >
                  {lang}
                </button>
              ))}
            </div>
          </div>
          <p className="text-gray-400 text-sm">
            © {new Date().getFullYear()} Cook-K. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}

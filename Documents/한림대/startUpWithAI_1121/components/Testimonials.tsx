"use client";

import { motion } from "framer-motion";
import { Star, Quote } from "lucide-react";
import Card from "./ui/Card";
import Image from "next/image";

const testimonials = [
  {
    name: "Sarah Chen",
    location: "San Francisco, CA",
    rating: 5,
    text: "The Bibimbap kit was incredible! Everything was fresh and the instructions were so clear. My family loved it!",
    image:
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
  },
  {
    name: "James Wilson",
    location: "London, UK",
    rating: 5,
    text: "Finally, authentic Korean food at home! The Tteokbokki was restaurant-quality. Highly recommend!",
    image:
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
  },
  {
    name: "Maria Garcia",
    location: "Barcelona, Spain",
    rating: 5,
    text: "As a K-drama fan, I love the cultural stories with each meal. The Bulgogi was amazing!",
    image:
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
  },
  {
    name: "David Kim",
    location: "Toronto, Canada",
    rating: 5,
    text: "Perfect for busy weeknights. The Japchae was ready in 20 minutes and tasted incredible!",
    image:
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
  },
];

const customerPhotos = [
  "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1544025162-d76694265947?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1603133872878-684f208fb84b?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80",
];

export default function Testimonials() {
  return (
    <section className="py-20 bg-primary-cream">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        {/* Trust Badges */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <div className="flex flex-col sm:flex-row items-center justify-center gap-8 mb-12">
            <div className="text-center">
              <div className="text-4xl font-bold text-primary-red mb-2">
                10,000+
              </div>
              <div className="text-gray-600">Happy Customers</div>
            </div>
            <div className="text-center">
              <div className="flex items-center justify-center gap-2 text-4xl font-bold text-primary-red mb-2">
                <Star className="w-8 h-8 fill-yellow-400 text-yellow-400" />
                4.9
              </div>
              <div className="text-gray-600">Rating</div>
            </div>
          </div>
        </motion.div>

        {/* Testimonials */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-bold text-primary-charcoal mb-4">
            What Our Customers Say
          </h2>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
          {testimonials.map((testimonial, index) => (
            <motion.div
              key={testimonial.name}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: index * 0.1, duration: 0.6 }}
            >
              <Card className="h-full">
                <Quote className="w-8 h-8 text-primary-red mb-4" />
                <div className="flex gap-1 mb-4">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star
                      key={i}
                      className="w-4 h-4 fill-yellow-400 text-yellow-400"
                    />
                  ))}
                </div>
                <p className="text-gray-600 mb-4 italic">
                  "{testimonial.text}"
                </p>
                <div className="flex items-center gap-3">
                  <div className="relative w-12 h-12 rounded-full overflow-hidden">
                    <Image
                      src={testimonial.image}
                      alt={testimonial.name}
                      fill
                      className="object-cover"
                      sizes="48px"
                    />
                  </div>
                  <div>
                    <div className="font-semibold text-primary-charcoal">
                      {testimonial.name}
                    </div>
                    <div className="text-sm text-gray-500">
                      {testimonial.location}
                    </div>
                  </div>
                </div>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Instagram-style Photo Grid */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="mb-8"
        >
          <h3 className="text-2xl font-bold text-primary-charcoal text-center mb-6">
            #MyKfoodMoment
          </h3>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-2">
            {customerPhotos.map((photo, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, scale: 0.8 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.05, duration: 0.4 }}
                className="relative aspect-square rounded-lg overflow-hidden"
              >
                <Image
                  src={photo}
                  alt={`Customer creation ${index + 1}`}
                  fill
                  className="object-cover hover:scale-110 transition-transform duration-300"
                  sizes="(max-width: 768px) 50vw, (max-width: 1024px) 33vw, 16vw"
                />
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>
    </section>
  );
}


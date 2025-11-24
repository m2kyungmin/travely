import { MealKit } from "@/types";

export const mealKits: MealKit[] = [
  {
    id: "1",
    nameKo: "비빔밥",
    nameEn: "Bibimbap",
    image:
      "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    cookingTime: 20,
    difficulty: "easy",
    price: 24.99,
    tags: ["vegetarian", "healthy"],
    story:
      "A colorful bowl of rice topped with fresh vegetables, a fried egg, and gochujang sauce.",
  },
  {
    id: "2",
    nameKo: "떡볶이",
    nameEn: "Tteokbokki",
    image:
      "https://images.unsplash.com/photo-1615485925510-7df0e662d8c2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    cookingTime: 15,
    difficulty: "easy",
    price: 19.99,
    tags: ["spicy", "street food"],
    story:
      "Chewy rice cakes in a sweet and spicy gochujang sauce, a beloved Korean street food.",
  },
  {
    id: "3",
    nameKo: "불고기",
    nameEn: "Bulgogi",
    image:
      "https://images.unsplash.com/photo-1558030006-450675393462?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    cookingTime: 25,
    difficulty: "medium",
    price: 29.99,
    tags: ["beef", "marinated"],
    story:
      "Thinly sliced marinated beef, grilled to perfection with a sweet and savory sauce.",
  },
  {
    id: "4",
    nameKo: "김치찌개",
    nameEn: "Kimchi Jjigae",
    image:
      "https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    cookingTime: 30,
    difficulty: "medium",
    price: 22.99,
    tags: ["spicy", "stew"],
    story:
      "A hearty stew made with aged kimchi, pork, and tofu, perfect for cold days.",
  },
  {
    id: "5",
    nameKo: "잡채",
    nameEn: "Japchae",
    image:
      "https://images.unsplash.com/photo-1603133872878-684f208fb84b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    cookingTime: 20,
    difficulty: "medium",
    price: 26.99,
    tags: ["noodles", "vegetarian"],
    story:
      "Sweet potato glass noodles stir-fried with vegetables and beef in a savory sauce.",
  },
];

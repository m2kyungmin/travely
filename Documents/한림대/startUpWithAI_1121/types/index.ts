export interface MealKit {
  id: string;
  nameKo: string;
  nameEn: string;
  image: string;
  cookingTime: number; // minutes
  difficulty: "easy" | "medium" | "hard";
  price: number;
  tags: string[];
  story: string;
}


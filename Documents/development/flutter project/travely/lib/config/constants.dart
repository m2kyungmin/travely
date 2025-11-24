class AppConstants {
  // 앱 정보
  static const String appName = '트래블리';
  static const String appTagline = '나만의 여행 성향 찾기';
  
  // 테스트 설정
  static const int totalQuestions = 16;
  static const int loadingDurationSeconds = 2;
  
  // 색상 (Hex to Color)
  static const int primaryColorValue = 0xFF4A90D9;
  static const int secondaryColorValue = 0xFFFF6B6B;
  static const int backgroundColorValue = 0xFFF8FAFC;
  
  // Firestore 컬렉션 이름
  static const String questionsCollection = 'questions';
  static const String typesCollection = 'types';
  static const String resultsCollection = 'results';
  
  // SharedPreferences 키
  static const String lastResultKey = 'last_test_result';
  
  // AdMob 테스트 광고 단위 ID
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String bannerAdUnitIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialAdUnitIdIOS = 'ca-app-pub-3940256099942544/4411468910';
  
  // 축 정의
  static const String axisRhythm = 'rhythm';
  static const String axisEnergy = 'energy';
  static const String axisBudget = 'budget';
  static const String axisConcept = 'concept';
  
  // 성향 코드
  static const String scoreSpontaneous = 'S';
  static const String scorePlanner = 'P';
  static const String scoreActive = 'A';
  static const String scoreRest = 'R';
  static const String scoreBudget = 'B';
  static const String scoreLuxury = 'L';
  static const String scoreNature = 'N';
  static const String scoreCity = 'C';
}


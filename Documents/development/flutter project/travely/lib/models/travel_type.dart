class Destination {
  final String name;
  final String description;
  final String imageUrl;
  final String affiliateLink;

  Destination({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.affiliateLink,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'affiliateLink': affiliateLink,
    };
  }

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      affiliateLink: json['affiliateLink'] ?? '',
    );
  }

  // Firestore 연동
  factory Destination.fromFirestore(Map<String, dynamic> data) {
    return Destination(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      affiliateLink: data['affiliateLink'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'affiliateLink': affiliateLink,
    };
  }
}

class TravelType {
  final String code;
  final String name;
  final String description;
  final String imageUrl;
  final Map<String, String> traits; // 각 축별 특징
  final List<Destination> destinations;

  TravelType({
    required this.code,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.traits,
    required this.destinations,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'traits': traits,
      'destinations': destinations.map((e) => e.toJson()).toList(),
    };
  }

  factory TravelType.fromJson(Map<String, dynamic> json) {
    return TravelType(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      traits: Map<String, String>.from(json['traits'] ?? {}),
      destinations: (json['destinations'] as List<dynamic>?)
              ?.map((e) => Destination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Firestore 연동
  factory TravelType.fromFirestore(Map<String, dynamic> data) {
    return TravelType(
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      traits: Map<String, String>.from(data['traits'] ?? {}),
      destinations: (data['destinations'] as List<dynamic>?)
              ?.map((e) => Destination.fromFirestore(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'traits': traits,
      'destinations': destinations.map((e) => e.toFirestore()).toList(),
    };
  }
}

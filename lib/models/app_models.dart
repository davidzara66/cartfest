const List<String> kClassifications = [
  'Pro',
  'Master',
  'Excelent',
  'Medium',
  'Amateur',
  'Iniciando',
  'Fanatico',
  'Entusiasta',
];

const List<String> kOrigins = ['Europeo', 'Asiatico', 'Americano'];

const List<String> kModificationCatalog = [
  'Escapes',
  'Intake',
  'Sistema encendido',
  'Pintura',
  'Piezas de carbono',
  'Performance de motor',
  'Frenos',
  'Suspension',
  'Body kit',
  'Spoiler',
  'Rines',
  'Iluminacion',
  'Accesorios',
  'Sonido interno',
];

class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String category;
  final String origin;
  final String ownerName;
  final String ownerClassification;
  final List<String> modifications;
  final String model3dPath;
  final int votes;
  final int trophies;
  final int year;
  final String color;
  final Map<String, double> stats;
  final String imageUrl;
  final String ownerPhotoUrl;
  final String ownerHandle;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.category,
    required this.origin,
    required this.ownerName,
    required this.ownerClassification,
    required this.modifications,
    required this.model3dPath,
    this.votes = 0,
    this.trophies = 0,
    required this.year,
    required this.color,
    required this.stats,
    this.imageUrl = '',
    this.ownerPhotoUrl = '',
    this.ownerHandle = '',
  });

  Vehicle copyWith({
    String? name,
    String? brand,
    String? model,
    String? category,
    String? origin,
    String? ownerName,
    String? ownerClassification,
    List<String>? modifications,
    int? votes,
    int? trophies,
    int? year,
    String? color,
    Map<String, double>? stats,
    String? imageUrl,
    String? ownerPhotoUrl,
    String? ownerHandle,
  }) {
    return Vehicle(
      id: id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      ownerName: ownerName ?? this.ownerName,
      ownerClassification: ownerClassification ?? this.ownerClassification,
      modifications: modifications ?? this.modifications,
      model3dPath: model3dPath,
      votes: votes ?? this.votes,
      trophies: trophies ?? this.trophies,
      year: year ?? this.year,
      color: color ?? this.color,
      stats: stats ?? this.stats,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerPhotoUrl: ownerPhotoUrl ?? this.ownerPhotoUrl,
      ownerHandle: ownerHandle ?? this.ownerHandle,
    );
  }
}

class Team {
  final String id;
  final String name;
  final String description;
  final String country;
  final String logoUrl;
  final List<String> memberIds;
  final int totalPoints;
  final int totalTrophies;
  final List<String> featuredVehicleIds;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.country,
    required this.logoUrl,
    required this.memberIds,
    this.totalPoints = 0,
    this.totalTrophies = 0,
    this.featuredVehicleIds = const [],
  });
}

class CarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final bool isLive;
  final List<String> registeredUserIds;

  CarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.isLive = false,
    this.registeredUserIds = const [],
  });
}

class UserProfile {
  final String id;
  final String name;
  final String handle;
  final String avatarUrl;
  final String bio;
  final String country;
  final String classification;
  final bool isPro;

  UserProfile({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.bio,
    required this.country,
    required this.classification,
    this.isPro = false,
  });

  UserProfile copyWith({
    String? name,
    String? handle,
    String? avatarUrl,
    String? bio,
    String? country,
    String? classification,
    bool? isPro,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      classification: classification ?? this.classification,
      isPro: isPro ?? this.isPro,
    );
  }
}

class FeedPost {
  final String id;
  final String authorId;
  final String vehicleId;
  final String caption;
  final DateTime createdAt;
  final int likes;
  final int comments;

  FeedPost({
    required this.id,
    required this.authorId,
    required this.vehicleId,
    required this.caption,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
  });
}

class StoryItem {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime createdAt;

  StoryItem({
    required this.id,
    required this.userId,
    required this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class ChatMessage {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.text,
    required this.timestamp,
  });
}

class EventChatMessage {
  final String id;
  final String author;
  final String text;
  final DateTime timestamp;

  EventChatMessage({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
  });
}

class EventRegistration {
  final String id;
  final String eventId;
  final String userId;
  final String vehicleName;
  final String vehicleBrand;
  final String vehiclePhotoUrl;
  final String category;
  final String origin;
  final String classification;
  final List<String> sections;
  final List<String> modifications;

  EventRegistration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.vehicleName,
    required this.vehicleBrand,
    required this.vehiclePhotoUrl,
    required this.category,
    required this.origin,
    required this.classification,
    required this.sections,
    required this.modifications,
  });
}

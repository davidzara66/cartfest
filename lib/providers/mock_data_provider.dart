import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/social_sync_service.dart';

class MockDataProvider extends ChangeNotifier {
  final SocialSyncService _sync = SocialSyncService();

  UserProfile _currentUser = UserProfile(
    id: 'u0',
    name: 'Luis Frio',
    handle: '@LuisFrioOficial',
    avatarUrl: 'https://images.unsplash.com/photo-1618641986557-1ecd230959aa?auto=format&fit=crop&w=300&q=80',
    bio: 'Creador de contenido tuning y organizador de eventos.',
    country: 'Argentina',
    classification: 'Pro',
    isPro: true,
  );

  final List<UserProfile> _users = [
    UserProfile(
      id: 'u1',
      name: 'Roberto Silva',
      handle: '@TurboKing',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
      bio: 'Especialista en motores europeos de alto rendimiento.',
      country: 'Brasil',
      classification: 'Master',
      isPro: true,
    ),
    UserProfile(
      id: 'u2',
      name: 'Carlos Mendez',
      handle: '@ElRey',
      avatarUrl: 'https://images.unsplash.com/photo-1545167622-3a6ac756afa4?auto=format&fit=crop&w=300&q=80',
      bio: 'Fanatico de los JDM y las pistas urbanas.',
      country: 'Mexico',
      classification: 'Excelent',
      isPro: true,
    ),
    UserProfile(
      id: 'u3',
      name: 'Ana Garcia',
      handle: '@SpeedQueen',
      avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=300&q=80',
      bio: 'Builds agresivos para circuito y calle.',
      country: 'Argentina',
      classification: 'Fanatico',
    ),
    UserProfile(
      id: 'u4',
      name: 'Neon Racer',
      handle: '@NeonRace',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
      bio: 'Diseno visual + potencia, sin compromisos.',
      country: 'Chile',
      classification: 'Entusiasta',
    ),
  ];

  final Set<String> _followingIds = {'u1', 'u2'};

  final List<Vehicle> _vehicles = [
    Vehicle(
      id: '1',
      name: '911 GT3 RS',
      brand: 'Porsche',
      model: '2024',
      category: 'Pro',
      origin: 'Europeo',
      ownerName: 'Roberto Silva',
      ownerClassification: 'Master',
      ownerHandle: '@TurboKing',
      modifications: ['Escapes', 'Frenos', 'Suspension', 'Body kit', 'Rines'],
      model3dPath: 'https://modelviewer.dev/shared-assets/models/sportsCar.glb',
      year: 2024,
      color: 'Blanco Carrara',
      stats: {'Power': 525, 'Motor': 9.5, 'Estetica': 9.8},
      votes: 312,
      trophies: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=80',
      ownerPhotoUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
    ),
    Vehicle(
      id: '2',
      name: 'GT-R R35',
      brand: 'Nissan',
      model: '2022',
      category: 'Master',
      origin: 'Asiatico',
      ownerName: 'Carlos Mendez',
      ownerClassification: 'Pro',
      ownerHandle: '@ElRey',
      modifications: ['Intake', 'Performance de motor', 'Body kit', 'Suspension'],
      model3dPath: 'https://modelviewer.dev/shared-assets/models/sportsCar.glb',
      year: 2022,
      color: 'Azul Bayside',
      stats: {'Power': 720, 'Motor': 9.9, 'Estetica': 9.0},
      votes: 246,
      trophies: 14,
      imageUrl:
          'https://images.unsplash.com/photo-1542282088-fe8426682b8f?auto=format&fit=crop&w=1200&q=80',
      ownerPhotoUrl:
          'https://images.unsplash.com/photo-1545167622-3a6ac756afa4?auto=format&fit=crop&w=300&q=80',
    ),
  ];

  final List<FeedPost> _posts = [
    FeedPost(
      id: 'p1',
      authorId: 'u2',
      vehicleId: '2',
      caption: 'Carlos Mendez presenta su Nissan GT-R R35 color Azul Bayside',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 246,
      comments: 12,
    ),
    FeedPost(
      id: 'p2',
      authorId: 'u1',
      vehicleId: '1',
      caption: 'Porsche 911 GT3 RS listo para el proximo evento nocturno.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      likes: 312,
      comments: 18,
    ),
  ];

  final List<StoryItem> _stories = [
    StoryItem(id: 's1', userId: 'u1', imageUrl: 'https://images.unsplash.com/photo-1494905998402-395d579af36f?auto=format&fit=crop&w=600&q=80'),
    StoryItem(id: 's2', userId: 'u2', imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=600&q=80'),
    StoryItem(id: 's3', userId: 'u3', imageUrl: 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=600&q=80'),
    StoryItem(id: 's4', userId: 'u4', imageUrl: 'https://images.unsplash.com/photo-1553440569-bcc63803a83d?auto=format&fit=crop&w=600&q=80'),
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      fromUserId: 'u1',
      toUserId: 'u0',
      text: 'Te paso specs para el evento?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 22)),
    ),
    ChatMessage(
      id: 'm2',
      fromUserId: 'u0',
      toUserId: 'u1',
      text: 'Si, enviame todo hoy.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
  ];

  final List<EventChatMessage> _eventChat = [
    EventChatMessage(id: 'ec1', author: 'User0', text: 'Ese build esta brutal, tremenda preparacion.', timestamp: DateTime.now()),
    EventChatMessage(id: 'ec2', author: 'User1', text: 'El setup de suspension quedo perfecto.', timestamp: DateTime.now()),
  ];

  final List<Team> _teams = [
    Team(
      id: 't1',
      name: 'Speed Demons Racing',
      description: 'Equipo top de tuning con enfoque en eventos nocturnos.',
      country: 'Argentina',
      logoUrl: 'https://placeholder.com/150',
      memberIds: ['u1', 'u2', 'u3'],
      totalPoints: 15400,
      totalTrophies: 28,
    ),
  ];

  final List<CarEvent> _events = [
    CarEvent(
      id: 'e1',
      title: 'Night Street Challenge',
      description: 'Competencia nocturna con iluminacion espectacular.',
      date: DateTime.now().add(const Duration(days: 4, hours: 23, minutes: 59)),
      location: 'Buenos Aires, Argentina',
      isLive: true,
    ),
  ];

  final List<EventRegistration> _eventRegistrations = [];

  UserProfile get currentUser => _currentUser;
  List<UserProfile> get users => _users;
  List<Vehicle> get vehicles => _vehicles;
  List<Team> get teams => _teams;
  List<CarEvent> get events => _events;
  List<FeedPost> get posts => _posts;
  List<StoryItem> get stories => _stories;
  List<EventChatMessage> get eventChat => _eventChat;
  List<EventRegistration> get eventRegistrations => _eventRegistrations;
  Set<String> get followingIds => _followingIds;

  UserProfile? findUserById(String id) {
    if (id == _currentUser.id) return _currentUser;
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  Vehicle? findVehicleById(String id) {
    for (final v in _vehicles) {
      if (v.id == id) return v;
    }
    return null;
  }

  void toggleFollow(String userId) {
    final following = !_followingIds.contains(userId);
    if (following) {
      _followingIds.add(userId);
    } else {
      _followingIds.remove(userId);
    }
    _sync.toggleFollow(
      followerId: _currentUser.id,
      followedId: userId,
      following: following,
    );
    notifyListeners();
  }

  List<ChatMessage> messagesWith(String userId) {
    return _messages
        .where((m) =>
            (m.fromUserId == _currentUser.id && m.toUserId == userId) ||
            (m.fromUserId == userId && m.toUserId == _currentUser.id))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void sendDirectMessage(String userId, String text) {
    if (text.trim().isEmpty) return;
    final msg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      fromUserId: _currentUser.id,
      toUserId: userId,
      text: text.trim(),
      timestamp: DateTime.now(),
    );
    _messages.add(msg);
    _sync.saveDirectMessage(msg);
    notifyListeners();
  }

  void sendEventChatMessage(String text) {
    if (text.trim().isEmpty) return;
    final msg = EventChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      author: _currentUser.name,
      text: text.trim(),
      timestamp: DateTime.now(),
    );
    _eventChat.add(msg);
    if (_events.isNotEmpty) {
      _sync.saveEventChat(_events.first.id, msg);
    }
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String handle,
    required String bio,
    required String country,
    required String avatarUrl,
    required String classification,
  }) {
    _currentUser = _currentUser.copyWith(
      name: name,
      handle: handle,
      bio: bio,
      country: country,
      avatarUrl: avatarUrl,
      classification: classification,
      isPro: classification == 'Pro' || classification == 'Master',
    );

    final index = _users.indexWhere((u) => u.id == _currentUser.id);
    if (index >= 0) {
      _users[index] = _currentUser;
    } else {
      _users.insert(0, _currentUser);
    }
    _sync.upsertProfile(_currentUser);
    notifyListeners();
  }

  void registerToEvent({
    required String eventId,
    required String vehicleName,
    required String vehicleBrand,
    required String vehiclePhotoUrl,
    required String category,
    required String origin,
    required String classification,
    required List<String> sections,
    required List<String> modifications,
  }) {
    final suffix = modifications.isEmpty ? '' : ' + ${modifications.join(' + ')}';
    final registration = EventRegistration(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      eventId: eventId,
      userId: _currentUser.id,
      vehicleName: '$vehicleName$suffix',
      vehicleBrand: vehicleBrand,
      vehiclePhotoUrl: vehiclePhotoUrl,
      category: category,
      origin: origin,
      classification: classification,
      sections: sections,
      modifications: modifications,
    );

    _eventRegistrations.add(registration);
    _sync.saveEventRegistration(registration);
    notifyListeners();
  }

  void addVehicleModification(String vehicleId, String modification) {
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index < 0) return;
    final old = _vehicles[index];
    if (old.modifications.contains(modification)) return;

    final updatedMods = [...old.modifications, modification];
    final updatedName = '${old.name} + $modification';
    _vehicles[index] = old.copyWith(name: updatedName, modifications: updatedMods);
    notifyListeners();
  }

  void voteForVehicle(String vehicleId) {
    notifyListeners();
  }
}

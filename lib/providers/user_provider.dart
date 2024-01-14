import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ktr/models/user_model_one.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

final userPlaceProvider =
    StateNotifierProvider<UserPlaceProviderNotifier, List<User>>(
  (ref) => UserPlaceProviderNotifier(),
);

class UserPlaceProviderNotifier extends StateNotifier<List<User>> {
  UserPlaceProviderNotifier() : super([]);
  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'user_information.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_information(userId TEX PRIMARY KEY,title TEXT,lat REAL,lng REAL,address TEXT)');
      },
      version: 1,
    );
    return db;
  }

  void addUser(String userName, String userEmail, String title,
      PlaceLocationOne placeLocation) async {
    final newUser = User(
        userName: userName,
        userEmail: userEmail,
        title: title,
        placeLocation: placeLocation);

    state = [newUser, ...state];

    final db = await _getDatabase();
    //insertion of data
    db.insert('user_information', {
      'id': newUser.userId,
      'title': newUser.title,
      'lat': newUser.placeLocation.latitude.toDouble(),
      'lng': newUser.placeLocation.longitude.toDouble(),
      'address': newUser.placeLocation.address,
    });
  }

  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('user_information');
    final user = data.map((e) {
      return User(
        placeLocation: PlaceLocationOne(
            latitude: e['lat'] as double,
            longitude: e['long'] as double,
            address: e['address'] as String),
        userName: e['userName'] as String,
        userEmail: e['userEmail'] as String,
        title: e['title'] as String,
      );
    }).toList();
    state = user;
  }
}

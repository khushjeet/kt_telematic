import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocationOne {
  const PlaceLocationOne(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class User {
  final String userId;
  final String userName;
  final String userEmail;
  final String title;

  final PlaceLocationOne placeLocation;

  User(
      {String? userId,
      required this.placeLocation,
      required this.userName,
      required this.userEmail,
      required this.title})
      : userId = userId ?? uuid.v4();

  User.fromMap(Map<String, dynamic> result)
      : placeLocation = result['placeLocation'],
        title = result['title'],
        userEmail = result['userEmail'],
        userName = result['userName'],
        userId = result['userId'];

  Map<String, dynamic> toMap() {
    return {
      'placeLocation': placeLocation,
      'title': title,
      'userEmail': userEmail,
      'userName': userName,
      'userId': userId,
    };
  }
}

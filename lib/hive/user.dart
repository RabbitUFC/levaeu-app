import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  User({
    this.id = '',
    this.jwtToken = '',
    this.name = '',
    this.photo = '',
    this.selectedType = 'passenger',
    this.isSignedIn = false,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String jwtToken;

  @HiveField(2)
  String name;

  @HiveField(3)
  String photo;

  @HiveField(4)
  String selectedType;

  @HiveField(5)
  bool isSignedIn;
}
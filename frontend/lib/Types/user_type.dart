enum UserType {
  PLAYER,
  FAMILY,
}

extension UserTypeExtension on UserType {
  String get name {
    switch (this) {
      case UserType.PLAYER:
        return "PLAYER";
      case UserType.FAMILY:
        return "FAMILY";
    }
  }
}
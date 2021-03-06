
class UserEntity {
  /// 用户id
  final String? id;
  /// 显示名称
  final String? displayName;
  /// 头像
  final String? photoUrl;

  UserEntity({this.id, this.displayName, this.photoUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode ^ photoUrl.hashCode;

  @override
  String toString() {
    return 'UserEntity{id: $id, displayName: $displayName, photoUrl: $photoUrl}';
  }
}

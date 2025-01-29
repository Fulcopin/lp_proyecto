import 'user_model.dart';

class FriendRequest {
  final int id;
  final int userId;
  final int friendId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User sender;

  FriendRequest({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    try {
      print('Debug - Parsing FriendRequest: $json');
      return FriendRequest(
        id: int.parse(json['id'].toString()),
        userId: int.parse(json['userId'].toString()),
        friendId: int.parse(json['friendId'].toString()),
        status: json['status'] as String,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      );
    } catch (e) {
      print('Debug - Parse error in FriendRequest: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sender': sender.toJson(),
    };
  }
}
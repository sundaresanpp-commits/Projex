import 'dart:typed_data';

enum ProjectSection { hackathon, patent, academic }

enum MessageStatus { sent, delivered, read }

class User {
  final String id;
  final String name;
  final String email;
  final String college;
  final String department;
  final String year;
  final String? avatarUrl;
  final String? bio;
  final List<String> skills;
  final int projectCount;
  final int followers;
  final int following;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.college,
    required this.department,
    required this.year,
    this.avatarUrl,
    this.bio,
    this.skills = const [],
    this.projectCount = 0,
    this.followers = 0,
    this.following = 0,
  });
}

class TeamMember {
  final String userId;
  final String name;
  final String role;
  final String? avatarUrl;

  const TeamMember({
    required this.userId,
    required this.name,
    required this.role,
    this.avatarUrl,
  });
}

class Project {
  final String id;
  final String title;
  final String description;
  final ProjectSection section;
  final String domain;
  final String college;
  final String mentorName;
  final List<TeamMember> teamMembers;
  final String? thumbnailUrl;
  int likes;
  int comments;
  final int views;
  final DateTime createdAt;
  final String authorId;
  final String authorName;
  final List<String> tags;
  final String? githubUrl;
  final String? demoUrl;
  bool isLiked;
  final Uint8List? thumbnailBytes;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.section,
    required this.domain,
    required this.college,
    required this.mentorName,
    required this.teamMembers,
    this.thumbnailUrl,
    required this.likes,
    required this.comments,
    required this.views,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    this.tags = const [],
    this.githubUrl,
    this.demoUrl,
    this.isLiked = false,
    this.thumbnailBytes,
  });

  String get sectionLabel {
    switch (section) {
      case ProjectSection.hackathon:
        return 'Hackathon';
      case ProjectSection.patent:
        return 'Patent';
      case ProjectSection.academic:
        return 'Academic';
    }
  }
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.status,
  });
}

class Conversation {
  final String id;
  final User otherUser;
  final Message lastMessage;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.otherUser,
    required this.lastMessage,
    required this.unreadCount,
  });
}

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    required this.createdAt,
  });
}

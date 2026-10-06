import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AppProvider extends ChangeNotifier {
  User? _currentUser;
  final List<User> _users = List<User>.from(mockUsers);
  List<Project> _projects = [];
  List<Conversation> _conversations = [];
  Map<String, List<Message>> _messages = {};
  Map<String, List<Comment>> _comments = {};
  ProjectSection? _activeSection;
  String _searchQuery = '';

  AppProvider() {
    _projects = List.from(mockProjects);
    _conversations = List.from(mockConversations);
    _messages = Map.from(mockMessages);
    _comments = {
      'p1': List<Comment>.from(mockComments),
    };
  }

  User? get currentUser => _currentUser;
  List<Conversation> get conversations => _conversations;
  Map<String, List<Message>> get messages => _messages;
  List<Comment> commentsForProject(String projectId) =>
      List.unmodifiable(_comments[projectId] ?? const []);
  ProjectSection? get activeSection => _activeSection;
  String get searchQuery => _searchQuery;

  List<Project> get filteredProjects {
    var list = _projects;
    if (_activeSection != null) {
      list = list.where((p) => p.section == _activeSection).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.domain.toLowerCase().contains(q) ||
              p.college.toLowerCase().contains(q) ||
              p.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }
    return list;
  }

  int projectCountForSection(ProjectSection section) {
    return _projects.where((p) => p.section == section).length;
  }

  bool get isLoggedIn => _currentUser != null;

  bool login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final matchingUsers = _users.where(
      (user) => user.email.toLowerCase() == normalizedEmail,
    );
    if (matchingUsers.isEmpty || password.length < 6) {
      return false;
    }
    _currentUser = matchingUsers.first;
    notifyListeners();
    return true;
  }

  void register(String name, String email, String college, String department,
      String year, String password) {
    final user = User(
      id: 'u_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      email: email,
      college: college,
      department: department,
      year: year,
      bio: '',
      skills: [],
    );
    _users.add(user);
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void setActiveSection(ProjectSection? section) {
    _activeSection = section;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleLike(String projectId) {
    final idx = _projects.indexWhere((p) => p.id == projectId);
    if (idx != -1) {
      final p = _projects[idx];
      p.isLiked = !p.isLiked;
      p.likes += p.isLiked ? 1 : -1;
      notifyListeners();
    }
  }

  void addProject(Project project) {
    _projects.insert(0, project);
    notifyListeners();
  }

  void sendMessage(String conversationId, String receiverId, String content) {
    final sender = _currentUser;
    if (sender == null) {
      return;
    }
    final msg = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: sender.id,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
    _messages[conversationId] = [
      ...(_messages[conversationId] ?? []),
      msg,
    ];
    final convIdx = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIdx != -1) {
      final old = _conversations[convIdx];
      _conversations[convIdx] = Conversation(
        id: old.id,
        otherUser: old.otherUser,
        lastMessage: msg,
        unreadCount: 0,
      );
    }
    notifyListeners();
  }

  void startConversation(User otherUser, String content) {
    if (_currentUser == null || content.trim().isEmpty) return;
    final existingConv =
        _conversations.where((c) => c.otherUser.id == otherUser.id).toList();
    if (existingConv.isNotEmpty) {
      sendMessage(existingConv.first.id, otherUser.id, content);
      return;
    }
    final convId = 'conv_${DateTime.now().millisecondsSinceEpoch}';
    final msg = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUser!.id,
      receiverId: otherUser.id,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
    _messages[convId] = [msg];
    _conversations.insert(
      0,
      Conversation(
        id: convId,
        otherUser: otherUser,
        lastMessage: msg,
        unreadCount: 0,
      ),
    );
    notifyListeners();
  }

  User? getUserById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    if (_currentUser?.id == id) return _currentUser;
    return null;
  }

  void markConversationRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1 || _conversations[index].unreadCount == 0) return;
    final conversation = _conversations[index];
    _conversations[index] = Conversation(
      id: conversation.id,
      otherUser: conversation.otherUser,
      lastMessage: conversation.lastMessage,
      unreadCount: 0,
    );
    notifyListeners();
  }

  void addComment(String projectId, String content) {
    final user = _currentUser;
    if (user == null || content.trim().isEmpty) return;
    final comment = Comment(
      id: 'comment_${DateTime.now().microsecondsSinceEpoch}',
      authorId: user.id,
      authorName: user.name,
      content: content.trim(),
      createdAt: DateTime.now(),
    );
    _comments[projectId] = [...(_comments[projectId] ?? []), comment];
    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) _projects[projectIndex].comments++;
    notifyListeners();
  }

  List<Project> getProjectsByUser(String userId) {
    return _projects.where((p) => p.authorId == userId).toList();
  }
}

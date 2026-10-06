import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/project_card.dart';
import '../messaging/conversation_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = userId != null
            ? provider.getUserById(userId!)
            : provider.currentUser;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Profile not found')),
          );
        }

        final isOwnProfile =
            userId == null || userId == provider.currentUser?.id;
        final projects = provider.getProjectsByUser(user.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, user, isOwnProfile, provider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(
                          context, user, isOwnProfile, provider),
                      const SizedBox(height: 20),
                      _buildStats(context, user, projects.length),
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _buildBio(context, user),
                      ],
                      if (user.skills.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _buildSkills(context, user),
                      ],
                      const SizedBox(height: 20),
                      _buildProjectsHeader(context, projects.length),
                    ],
                  ),
                ),
              ),
              if (projects.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEmptyProjects(context),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => ProjectCard(project: projects[i]),
                    childCount: projects.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, User user, bool isOwnProfile,
      AppProvider provider) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface,
      actions: [
        if (isOwnProfile)
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              provider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        if (!isOwnProfile)
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () => _showMessageDialog(context, user, provider),
          ),
        if (!isOwnProfile)
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: 'Check out ${user.name} on AcademiQ'),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile link copied.')),
              );
            },
          ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user, bool isOwnProfile,
      AppProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 4),
              Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.school_outlined,
                      size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${user.college} · ${user.department}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.year,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, User user, int projectCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _statItem(context, '$projectCount', 'Projects'),
          _divider(),
          _statItem(context, '${user.followers}', 'Followers'),
          _divider(),
          _statItem(context, '${user.following}', 'Following'),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 36, width: 1, color: AppColors.border);
  }

  Widget _buildBio(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(user.bio!,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
      ],
    );
  }

  Widget _buildSkills(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skills', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.skills
              .map((s) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(s,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500)),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProjectsHeader(BuildContext context, int count) {
    return Text(
      'Projects ($count)',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildEmptyProjects(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.folder_open_rounded,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text('No projects yet',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Upload your first project to get started',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showMessageDialog(
      BuildContext context, User user, AppProvider provider) {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Message ${user.name}'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write a message...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                provider.startConversation(user, ctrl.text);
                Navigator.pop(context);
                final conversation = provider.conversations.firstWhere(
                  (c) => c.otherUser.id == user.id,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationScreen(
                      conversationId: conversation.id,
                      otherUser: user,
                    ),
                  ),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

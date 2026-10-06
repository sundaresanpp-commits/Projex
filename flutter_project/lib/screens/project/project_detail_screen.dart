import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../profile/profile_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Color get _sectionColor {
    switch (widget.project.section) {
      case ProjectSection.hackathon:
        return AppColors.hackathon;
      case ProjectSection.patent:
        return AppColors.patent;
      case ProjectSection.academic:
        return AppColors.project;
    }
  }

  Color get _sectionBg {
    switch (widget.project.section) {
      case ProjectSection.hackathon:
        return AppColors.hackathonLight;
      case ProjectSection.patent:
        return AppColors.patentLight;
      case ProjectSection.academic:
        return AppColors.projectLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTagsRow(),
                  const SizedBox(height: 14),
                  Text(widget.project.title,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 8),
                  _buildStats(),
                  const SizedBox(height: 20),
                  _buildDescription(context),
                  const SizedBox(height: 20),
                  _buildMentorInfo(context),
                  const SizedBox(height: 20),
                  _buildTeamSection(context),
                  if (widget.project.tags.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildTagsSection(context),
                  ],
                  if (widget.project.githubUrl != null ||
                      widget.project.demoUrl != null) ...[
                    const SizedBox(height: 20),
                    _buildLinks(context),
                  ],
                  const SizedBox(height: 20),
                  _buildCommentsSection(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: widget.project.thumbnailUrl != null ? 240 : 120,
      pinned: true,
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.project.thumbnailBytes != null
            ? Image.memory(widget.project.thumbnailBytes!, fit: BoxFit.cover)
            : widget.project.thumbnailUrl != null
                ? Image.network(
                    widget.project.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _sectionBg,
                      child: Center(
                        child: Icon(Icons.image_outlined,
                            size: 48, color: _sectionColor),
                      ),
                    ),
                  )
                : Container(
                    color: _sectionBg,
                    child: Center(
                      child: Icon(Icons.school_rounded,
                          size: 48, color: _sectionColor),
                    ),
                  ),
      ),
    );
  }

  Widget _buildTagsRow() {
    return Row(
      children: [
        _chip(widget.project.sectionLabel, _sectionColor, _sectionBg),
        const SizedBox(width: 8),
        _chip(
          widget.project.domain,
          AppColors.textSecondary,
          AppColors.background,
          border: true,
        ),
      ],
    );
  }

  Widget _chip(String label, Color textColor, Color bg, {bool border = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  Widget _buildStats() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) => Row(
        children: [
          _stat(
            icon: widget.project.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            value: '${widget.project.likes}',
            color: widget.project.isLiked ? Colors.red : AppColors.textMuted,
            onTap: () => provider.toggleLike(widget.project.id),
          ),
          const SizedBox(width: 20),
          _stat(
            icon: Icons.chat_bubble_outline_rounded,
            value: '${widget.project.comments}',
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 20),
          _stat(
            icon: Icons.visibility_outlined,
            value: '${widget.project.views}',
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _stat({
    required IconData icon,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 5),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About This Project',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text(widget.project.description,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
      ],
    );
  }

  Widget _buildMentorInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.school_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mentor',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500)),
                Text(widget.project.mentorName,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(widget.project.college,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Team Members', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        ...widget.project.teamMembers
            .map((member) => _teamMemberTile(context, member)),
      ],
    );
  }

  Widget _teamMemberTile(BuildContext context, TeamMember member) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          final user = context.read<AppProvider>().getUserById(member.userId);
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen(userId: user.id)),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  member.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                    Text(member.role,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.project.tags
              .map((tag) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Links', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        if (widget.project.githubUrl != null)
          _linkTile(Icons.code_rounded, 'GitHub Repository',
              widget.project.githubUrl!),
        if (widget.project.demoUrl != null)
          _linkTile(
              Icons.open_in_new_rounded, 'Live Demo', widget.project.demoUrl!),
      ],
    );
  }

  Widget _linkTile(IconData icon, String label, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri == null || !await launchUrl(uri)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open this link.')),
          );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments (${widget.project.comments})',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        ...context
            .watch<AppProvider>()
            .commentsForProject(widget.project.id)
            .map((c) => _commentTile(context, c)),
      ],
    );
  }

  Widget _commentTile(BuildContext context, Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              comment.authorName[0].toUpperCase(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.authorName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(comment.content,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentCtrl,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              onPressed: () {
                context.read<AppProvider>().addComment(
                      widget.project.id,
                      _commentCtrl.text,
                    );
                _commentCtrl.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}

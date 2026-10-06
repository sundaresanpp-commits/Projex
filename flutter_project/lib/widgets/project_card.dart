import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../screens/project/project_detail_screen.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  Color get _sectionColor {
    switch (project.section) {
      case ProjectSection.hackathon:
        return AppColors.hackathon;
      case ProjectSection.patent:
        return AppColors.patent;
      case ProjectSection.academic:
        return AppColors.project;
    }
  }

  Color get _sectionBg {
    switch (project.section) {
      case ProjectSection.hackathon:
        return AppColors.hackathonLight;
      case ProjectSection.patent:
        return AppColors.patentLight;
      case ProjectSection.academic:
        return AppColors.projectLight;
    }
  }

  IconData get _sectionIcon {
    switch (project.section) {
      case ProjectSection.hackathon:
        return Icons.emoji_events_rounded;
      case ProjectSection.patent:
        return Icons.verified_rounded;
      case ProjectSection.academic:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(project: project),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTags(context),
                  const SizedBox(height: 10),
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _buildMeta(context),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (project.thumbnailBytes != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.memory(project.thumbnailBytes!,
            height: 180, width: double.infinity, fit: BoxFit.cover),
      );
    }
    if (project.thumbnailUrl == null) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: _sectionBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Center(
          child: Icon(_sectionIcon, color: _sectionColor, size: 48),
        ),
      );
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        project.thumbnailUrl!,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 180,
          color: _sectionBg,
          child: Center(
            child: Icon(_sectionIcon, color: _sectionColor, size: 48),
          ),
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    return Row(
      children: [
        _sectionChip(),
        const SizedBox(width: 8),
        _domainChip(context),
      ],
    );
  }

  Widget _sectionChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _sectionBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_sectionIcon, size: 12, color: _sectionColor),
          const SizedBox(width: 4),
          Text(
            project.sectionLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _sectionColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _domainChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        project.domain,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMeta(BuildContext context) {
    return Column(
      children: [
        _metaRow(Icons.school_outlined, project.college),
        const SizedBox(height: 4),
        _metaRow(Icons.person_outline, 'Mentor: ${project.mentorName}'),
      ],
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        _authorAvatar(context),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.authorName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _formatDate(project.createdAt),
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        _engagementMetrics(context),
      ],
    );
  }

  Widget _authorAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        project.authorName[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _engagementMetrics(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            GestureDetector(
              onTap: () => provider.toggleLike(project.id),
              child: Row(
                children: [
                  Icon(
                    project.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: project.isLiked ? Colors.red : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.likes}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded,
                    size: 16, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${project.comments}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

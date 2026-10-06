import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/project_card.dart';
import '../project/upload_project_screen.dart';
import '../profile/profile_screen.dart';
import '../messaging/inbox_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: const [
          _FeedTab(),
          InboxScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentNavIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadProjectScreen()),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Upload Project',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.surface,
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildAppBar(context),
        _buildSearchBar(context),
        _buildSectionTabs(context),
      ],
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final projects = provider.filteredProjects;
          if (projects.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: projects.length,
            itemBuilder: (_, i) => ProjectCard(project: projects[i]),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surface,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          const Text(
            'AcademiQ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: TextField(
          onChanged: (v) => context.read<AppProvider>().setSearchQuery(v),
          decoration: InputDecoration(
            hintText: 'Search projects, domains, colleges...',
            prefixIcon:
                const Icon(Icons.search_rounded, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTabs(BuildContext context) {
    return SliverToBoxAdapter(child: _SectionTabs());
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 56, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text('No projects found',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Try a different search or filter',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColors.surface,
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _SectionTab(
                  label: 'All',
                  count: null,
                  isActive: provider.activeSection == null,
                  color: AppColors.primary,
                  bgColor: AppColors.primaryLight,
                  onTap: () => provider.setActiveSection(null),
                ),
                const SizedBox(width: 8),
                _SectionTab(
                  label: 'Hackathon',
                  count:
                      provider.projectCountForSection(ProjectSection.hackathon),
                  isActive: provider.activeSection == ProjectSection.hackathon,
                  color: AppColors.hackathon,
                  bgColor: AppColors.hackathonLight,
                  icon: Icons.emoji_events_rounded,
                  onTap: () =>
                      provider.setActiveSection(ProjectSection.hackathon),
                ),
                const SizedBox(width: 8),
                _SectionTab(
                  label: 'Patent',
                  count: provider.projectCountForSection(ProjectSection.patent),
                  isActive: provider.activeSection == ProjectSection.patent,
                  color: AppColors.patent,
                  bgColor: AppColors.patentLight,
                  icon: Icons.verified_rounded,
                  onTap: () => provider.setActiveSection(ProjectSection.patent),
                ),
                const SizedBox(width: 8),
                _SectionTab(
                  label: 'Academic',
                  count:
                      provider.projectCountForSection(ProjectSection.academic),
                  isActive: provider.activeSection == ProjectSection.academic,
                  color: AppColors.project,
                  bgColor: AppColors.projectLight,
                  icon: Icons.school_rounded,
                  onTap: () =>
                      provider.setActiveSection(ProjectSection.academic),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTab extends StatelessWidget {
  final String label;
  final int? count;
  final bool isActive;
  final Color color;
  final Color bgColor;
  final IconData? icon;
  final VoidCallback onTap;

  const _SectionTab({
    required this.label,
    required this.count,
    required this.isActive,
    required this.color,
    required this.bgColor,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isActive ? Colors.white : color),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color:
                      isActive ? Colors.white.withValues(alpha: 0.25) : bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

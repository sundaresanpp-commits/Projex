import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class UploadProjectScreen extends StatefulWidget {
  const UploadProjectScreen({super.key});

  @override
  State<UploadProjectScreen> createState() => _UploadProjectScreenState();
}

class _UploadProjectScreenState extends State<UploadProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _mentorCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _demoCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  ProjectSection _section = ProjectSection.academic;
  String _domain = 'AI/ML';
  final List<String> _tags = [];
  final List<TeamMember> _teamMembers = [];
  bool _isLoading = false;
  Uint8List? _thumbnailBytes;

  final List<String> _domains = [
    'AI/ML',
    'IoT',
    'Robotics',
    'Blockchain',
    'Web Dev',
    'Mobile Dev',
    'Computer Vision',
    'Data Science',
    'Cybersecurity',
    'Other'
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _mentorCtrl.dispose();
    _githubCtrl.dispose();
    _demoCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagCtrl.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagCtrl.clear();
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final provider = context.read<AppProvider>();
    final user = provider.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in before uploading.')),
      );
      return;
    }
    final project = Project(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text,
      description: _descCtrl.text,
      section: _section,
      domain: _domain,
      college: user.college,
      mentorName: _mentorCtrl.text,
      teamMembers: [
        TeamMember(userId: user.id, name: user.name, role: 'Lead'),
        ..._teamMembers,
      ],
      likes: 0,
      comments: 0,
      views: 0,
      createdAt: DateTime.now(),
      authorId: user.id,
      authorName: user.name,
      tags: _tags,
      githubUrl: _githubCtrl.text.isNotEmpty ? _githubCtrl.text : null,
      demoUrl: _demoCtrl.text.isNotEmpty ? _demoCtrl.text : null,
      thumbnailBytes: _thumbnailBytes,
    );
    provider.addProject(project);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project uploaded successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Project'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  )
                : const Text('Publish',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionPicker(),
            const SizedBox(height: 20),
            _buildThumbnailPicker(),
            const SizedBox(height: 20),
            _sectionHeader('Project Details'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Project Title *'),
              validator: (v) => v!.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _domain,
              decoration: const InputDecoration(labelText: 'Domain *'),
              items: _domains
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _domain = v!),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description *',
                alignLabelWithHint: true,
              ),
              validator: (v) => v!.isEmpty ? 'Description is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _mentorCtrl,
              decoration: const InputDecoration(
                labelText: 'Mentor Name *',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => v!.isEmpty ? 'Mentor name is required' : null,
            ),
            const SizedBox(height: 20),
            _sectionHeader('Tags'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Add a tag...',
                      prefixIcon: Icon(Icons.tag_rounded),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTag,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          onDeleted: () => setState(() => _tags.remove(tag)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
            _sectionHeader('Links (Optional)'),
            const SizedBox(height: 12),
            TextField(
              controller: _githubCtrl,
              decoration: const InputDecoration(
                labelText: 'GitHub URL',
                prefixIcon: Icon(Icons.code_rounded),
                hintText: 'https://github.com/...',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _demoCtrl,
              decoration: const InputDecoration(
                labelText: 'Demo URL',
                prefixIcon: Icon(Icons.open_in_new_rounded),
                hintText: 'https://...',
              ),
            ),
            const SizedBox(height: 20),
            _buildTeamSection(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Upload Project'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Project Category'),
        const SizedBox(height: 12),
        Row(
          children: [
            _sectionOption(
                ProjectSection.academic,
                'Academic',
                Icons.school_rounded,
                AppColors.project,
                AppColors.projectLight),
            const SizedBox(width: 8),
            _sectionOption(
                ProjectSection.hackathon,
                'Hackathon',
                Icons.emoji_events_rounded,
                AppColors.hackathon,
                AppColors.hackathonLight),
            const SizedBox(width: 8),
            _sectionOption(
                ProjectSection.patent,
                'Patent',
                Icons.verified_rounded,
                AppColors.patent,
                AppColors.patentLight),
          ],
        ),
      ],
    );
  }

  Widget _sectionOption(ProjectSection section, String label, IconData icon,
      Color color, Color bg) {
    final isSelected = _section == section;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _section = section),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPicker() {
    return GestureDetector(
      onTap: _pickThumbnail,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: _thumbnailBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(_thumbnailBytes!,
                    width: double.infinity, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.add_photo_alternate_outlined,
                        color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text('Add Thumbnail',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  const Text('JPG, PNG up to 10MB',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
      ),
    );
  }

  Future<void> _pickThumbnail() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() => _thumbnailBytes = bytes);
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionHeader('Team Members'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showAddMemberDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  context
                          .read<AppProvider>()
                          .currentUser
                          ?.name
                          .characters
                          .first ??
                      '?',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text('Lead (You)',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        ..._teamMembers.map((m) => Padding(
              padding: const EdgeInsets.only(top: 8),
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
                      radius: 18,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(m.name[0],
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          Text(m.role,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          size: 18, color: AppColors.textMuted),
                      onPressed: () => setState(() => _teamMembers.remove(m)),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  void _showAddMemberDialog() {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Team Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && roleCtrl.text.isNotEmpty) {
                setState(() {
                  _teamMembers.add(TeamMember(
                    userId: 'u_external_${_teamMembers.length}',
                    name: nameCtrl.text,
                    role: roleCtrl.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineMedium);
  }
}

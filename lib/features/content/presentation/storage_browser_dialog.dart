import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_theme.dart';
import '../data/content_download_manager.dart';
import '../domain/content_type.dart';
import '../domain/local_custom_item.dart';
import 'content_providers.dart';

/// Interactive file & folder browser dialog for importing local offline content.
/// Supports exploring device storage, picking `.zip` files, or selecting folders.
class StorageBrowserDialog extends ConsumerStatefulWidget {
  const StorageBrowserDialog({super.key, this.initialType = ContentType.book});

  final ContentType initialType;

  static Future<void> show(BuildContext context, {ContentType initialType = ContentType.book}) {
    return showDialog(
      context: context,
      builder: (context) => StorageBrowserDialog(initialType: initialType),
    );
  }

  @override
  ConsumerState<StorageBrowserDialog> createState() => _StorageBrowserDialogState();
}

class _StorageBrowserDialogState extends ConsumerState<StorageBrowserDialog> {
  late ContentType _selectedType;
  Directory _currentDir = Directory.current;
  List<FileSystemEntity> _entities = [];
  bool _loading = false;
  String? _statusMessage;
  final TextEditingController _pathInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _initInitialDirectory();
  }

  @override
  void dispose() {
    _pathInputController.dispose();
    super.dispose();
  }

  Future<void> _initInitialDirectory() async {
    setState(() => _loading = true);
    try {
      Directory startDir;
      if (Platform.isWindows) {
        startDir = Directory.current;
      } else if (Platform.isAndroid) {
        final ext = await getExternalStorageDirectory();
        startDir = ext ?? Directory('/storage/emulated/0');
      } else {
        startDir = await getApplicationDocumentsDirectory();
      }

      if (await startDir.exists()) {
        _currentDir = startDir;
      } else {
        _currentDir = Directory.current;
      }
      await _loadDirectory(_currentDir);
    } catch (_) {
      _currentDir = Directory('/');
      await _loadDirectory(_currentDir);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadDirectory(Directory dir) async {
    setState(() {
      _loading = true;
      _currentDir = dir;
    });

    try {
      final list = await dir.list().toList();
      list.sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;
        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;
        return a.path.toLowerCase().compareTo(b.path.toLowerCase());
      });

      if (mounted) {
        setState(() {
          _entities = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _entities = [];
          _loading = false;
        });
      }
    }
  }

  void _navigateUp() {
    final parent = _currentDir.parent;
    if (parent.path != _currentDir.path) {
      _loadDirectory(parent);
    }
  }

  bool _isZip(FileSystemEntity entity) =>
      entity is File && entity.path.toLowerCase().endsWith('.zip');

  bool _hasContentJson(Directory dir) => File('${dir.path}/content.json').existsSync();

  Future<void> _importZip(File file) async {
    setState(() {
      _loading = true;
      _statusMessage = 'جاري استخراج وفحص الحزمة المضغوطة...';
    });

    try {
      final manager = ref.read(contentDownloadManagerProvider);
      final targetDir = await manager.importZipFile(file);
      await _finishImport(targetDir);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الاستيراد: ${e.toString().replaceAll('Exception:', '')}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _statusMessage = null;
        });
      }
    }
  }

  Future<void> _importFolder(Directory dir) async {
    setState(() {
      _loading = true;
      _statusMessage = 'جاري نسخ وفحص محتويات المجلد...';
    });

    try {
      final manager = ref.read(contentDownloadManagerProvider);
      final targetDir = await manager.importFolder(dir);
      await _finishImport(targetDir);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الاستيراد: ${e.toString().replaceAll('Exception:', '')}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _statusMessage = null;
        });
      }
    }
  }

  Future<void> _importFromInputPath() async {
    final path = _pathInputController.text.trim();
    if (path.isEmpty) return;

    final file = File(path);
    if (await file.exists() && path.toLowerCase().endsWith('.zip')) {
      await _importZip(file);
      return;
    }

    final dir = Directory(path);
    if (await dir.exists()) {
      await _importFolder(dir);
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('المسار المحدد غير موجود أو غير صالح')));
    }
  }

  Future<void> _finishImport(Directory targetDir) async {
    final folderName = targetDir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    String title = folderName;
    ContentType detectedType = _selectedType;

    try {
      final manifestFile = File('${targetDir.path}/content.json');
      if (manifestFile.existsSync()) {
        final json = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
        if (json.containsKey('index') && json['index'] is List) {
          detectedType = ContentType.book;
        } else if (json.containsKey('html')) {
          detectedType = _selectedType == ContentType.book ? ContentType.game : _selectedType;
        }
        if (json['title'] != null) {
          title = json['title'].toString();
        }
      }
    } catch (_) {}

    final customItem = LocalCustomItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      folder: folderName,
      contentType: detectedType,
      isCustom: true,
    );

    await ref.read(customItemsProvider.notifier).addCustomItem(customItem);
    ref.invalidate(contentItemsProvider(detectedType));

    if (!mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم استيراد "$title" بنجاح وهو متاح بدون إنترنت!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'تشغيل الآن',
          textColor: Colors.white,
          onPressed: () {
            context.push('/content/player', extra: customItem);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.folder_zip_rounded, color: theme.colorScheme.primary, size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'استيراد محتوى محلي (أوفلاين)',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'اختر ملف .zip أو مجلداً يحتوي على content.json لتشغيل الكتاب أو اللعبة بدون إنترنت.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Text('نوع المحتوى: '),
                    const SizedBox(width: AppSpacing.sm),
                    DropdownButton<ContentType>(
                      value: _selectedType,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                      items: const [
                        DropdownMenuItem(value: ContentType.book, child: Text('القصص التفاعلية')),
                        DropdownMenuItem(value: ContentType.game, child: Text('الألعاب التعليمية')),
                        DropdownMenuItem(value: ContentType.quran, child: Text('القرآن الكريم')),
                        DropdownMenuItem(
                          value: ContentType.soundBook,
                          child: Text('الكتب الصوتية'),
                        ),
                      ],
                    ),
                  ],
                ),
                const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.folder_open), text: 'متصفح الملفات'),
                    Tab(icon: Icon(Icons.link), text: 'مسار مباشر'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              if (_statusMessage != null) ...[
                                const SizedBox(height: AppSpacing.md),
                                Text(_statusMessage!, style: theme.textTheme.bodyMedium),
                              ],
                            ],
                          ),
                        )
                      : TabBarView(
                          children: [_buildExplorerTab(theme), _buildDirectPathTab(theme)],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplorerTab(ThemeData theme) {
    final canImportCurrentDir = _hasContentJson(_currentDir);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward_rounded),
                tooltip: 'المجلد الأعلى',
                onPressed: _navigateUp,
              ),
              Expanded(
                child: Text(
                  _currentDir.path,
                  style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canImportCurrentDir)
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.download_done_rounded, size: 18),
                  label: const Text('استيراد هذا المجلد'),
                  onPressed: () => _importFolder(_currentDir),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: _entities.isEmpty
              ? const Center(child: Text('المجلد فارغ أو تعذر الوصول إليه'))
              : ListView.separated(
                  itemCount: _entities.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _entities[index];
                    final name = item.uri.pathSegments.where((s) => s.isNotEmpty).last;
                    final isDir = item is Directory;
                    final isZipFile = _isZip(item);

                    if (!isDir && !isZipFile) {
                      return const SizedBox.shrink();
                    }

                    return ListTile(
                      dense: true,
                      leading: Icon(
                        isDir ? Icons.folder_rounded : Icons.folder_zip_rounded,
                        color: isDir ? Colors.amber[700] : theme.colorScheme.primary,
                      ),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: isDir
                          ? (_hasContentJson(item)
                                ? const Text(
                                    'يحتوي على content.json (جاهز للاستيراد)',
                                    style: TextStyle(color: Colors.green),
                                  )
                                : null)
                          : const Text('حزمة مضغوطة .zip', style: TextStyle(color: Colors.blue)),
                      trailing: isZipFile
                          ? FilledButton.icon(
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text('استيراد'),
                              onPressed: () => _importZip(item as File),
                            )
                          : (isDir && _hasContentJson(item)
                                ? OutlinedButton.icon(
                                    icon: const Icon(Icons.download, size: 16),
                                    label: const Text('استيراد'),
                                    onPressed: () => _importFolder(item),
                                  )
                                : const Icon(Icons.chevron_left_rounded)),
                      onTap: () {
                        if (isDir) {
                          _loadDirectory(item);
                        } else if (isZipFile) {
                          _importZip(item as File);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDirectPathTab(ThemeData theme) {
    // Scrollable: in landscape the open keyboard leaves too little height.
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('أدخل المسار الكامل لملف Zip أو مجلد على جهازك:', style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _pathInputController,
          decoration: InputDecoration(
            hintText: Platform.isWindows
                ? 'مثال: D:\\contents\\book1.zip'
                : 'مثال: /storage/emulated/0/Download/game.zip',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.folder),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          icon: const Icon(Icons.file_download),
          label: const Text('بدء الاستيراد والتشغيل أوفلاين'),
          onPressed: _importFromInputPath,
        ),
      ],
    );
  }
}

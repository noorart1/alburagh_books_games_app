import 'content_item.dart';
import 'content_type.dart';

/// Represents a locally imported or custom offline item (book, game, etc.)
/// that may not exist in the remote API catalog.
class LocalCustomItem implements ContentItem {
  LocalCustomItem({
    required this.id,
    required this.title,
    required this.folder,
    required this.contentType,
    this.fileUrl = '',
    this.coverImageUrl = '',
    this.description = '',
    this.author = '',
    this.order = 9999,
    this.version = 1.0,
    DateTime? date,
    this.samples = const [],
    this.readings,
    this.isCustom = true,
  }) : date = date ?? DateTime(2026, 1, 1);

  factory LocalCustomItem.fromJson(Map<String, dynamic> json) => LocalCustomItem(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] as String? ?? 'محتوى بدون عنوان',
        folder: json['folder'] as String,
        contentType: ContentType.values.byName(json['content_type'] as String? ?? 'book'),
        fileUrl: json['file_url'] as String? ?? '',
        coverImageUrl: json['cover_image_url'] as String? ?? '',
        description: json['description'] as String? ?? '',
        author: json['author'] as String? ?? '',
        order: (json['order'] as num?)?.toInt() ?? 9999,
        version: (json['version'] as num?)?.toDouble() ?? 1.0,
        date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
        samples: (json['samples'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
        readings: (json['readings'] as num?)?.toInt(),
        isCustom: json['is_custom'] as bool? ?? true,
      );

  @override
  final String id;
  @override
  final String title;
  @override
  final String folder;
  @override
  final ContentType contentType;
  @override
  final String fileUrl;
  @override
  final String coverImageUrl;
  final String description;
  final String author;
  @override
  final int order;
  @override
  final double version;
  @override
  final DateTime date;
  @override
  final List<String> samples;
  @override
  final int? readings;
  final bool isCustom;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'folder': folder,
        'content_type': contentType.name,
        'file_url': fileUrl,
        'cover_image_url': coverImageUrl,
        'description': description,
        'author': author,
        'order': order,
        'version': version,
        'date': date.toIso8601String(),
        'samples': samples,
        'readings': readings,
        'is_custom': isCustom,
      };
}


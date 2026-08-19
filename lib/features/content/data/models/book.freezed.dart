// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;
  String? get series => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromString)
  double get rate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromString)
  int get downloads => throw _privateConstructorUsedError;
  @JsonKey(fromJson: nullableIntFromString)
  int? get readings => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String? get illistrator => throw _privateConstructorUsedError;
  String get publisher => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_group')
  String get ageGroup => throw _privateConstructorUsedError;
  String get cover => throw _privateConstructorUsedError;
  String get file => throw _privateConstructorUsedError;
  @JsonKey(fromJson: intFromString)
  int get order => throw _privateConstructorUsedError;
  String get folder => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromString)
  double get version => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  String get fileSize => throw _privateConstructorUsedError;
  List<String> get samples => throw _privateConstructorUsedError;

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call({
    String id,
    String title,
    String lang,
    String? series,
    String description,
    @JsonKey(fromJson: doubleFromString) double rate,
    @JsonKey(fromJson: intFromString) int downloads,
    @JsonKey(fromJson: nullableIntFromString) int? readings,
    String author,
    String? illistrator,
    String publisher,
    @JsonKey(name: 'age_group') String ageGroup,
    String cover,
    String file,
    @JsonKey(fromJson: intFromString) int order,
    String folder,
    @JsonKey(fromJson: doubleFromString) double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    DateTime date,
    @JsonKey(name: 'file_size') String fileSize,
    List<String> samples,
  });
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lang = null,
    Object? series = freezed,
    Object? description = null,
    Object? rate = null,
    Object? downloads = null,
    Object? readings = freezed,
    Object? author = null,
    Object? illistrator = freezed,
    Object? publisher = null,
    Object? ageGroup = null,
    Object? cover = null,
    Object? file = null,
    Object? order = null,
    Object? folder = null,
    Object? version = null,
    Object? date = null,
    Object? fileSize = null,
    Object? samples = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            lang: null == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                      as String,
            series: freezed == series
                ? _value.series
                : series // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            rate: null == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                      as double,
            downloads: null == downloads
                ? _value.downloads
                : downloads // ignore: cast_nullable_to_non_nullable
                      as int,
            readings: freezed == readings
                ? _value.readings
                : readings // ignore: cast_nullable_to_non_nullable
                      as int?,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            illistrator: freezed == illistrator
                ? _value.illistrator
                : illistrator // ignore: cast_nullable_to_non_nullable
                      as String?,
            publisher: null == publisher
                ? _value.publisher
                : publisher // ignore: cast_nullable_to_non_nullable
                      as String,
            ageGroup: null == ageGroup
                ? _value.ageGroup
                : ageGroup // ignore: cast_nullable_to_non_nullable
                      as String,
            cover: null == cover
                ? _value.cover
                : cover // ignore: cast_nullable_to_non_nullable
                      as String,
            file: null == file
                ? _value.file
                : file // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            folder: null == folder
                ? _value.folder
                : folder // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as double,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fileSize: null == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as String,
            samples: null == samples
                ? _value.samples
                : samples // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookImplCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$BookImplCopyWith(
    _$BookImpl value,
    $Res Function(_$BookImpl) then,
  ) = __$$BookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String lang,
    String? series,
    String description,
    @JsonKey(fromJson: doubleFromString) double rate,
    @JsonKey(fromJson: intFromString) int downloads,
    @JsonKey(fromJson: nullableIntFromString) int? readings,
    String author,
    String? illistrator,
    String publisher,
    @JsonKey(name: 'age_group') String ageGroup,
    String cover,
    String file,
    @JsonKey(fromJson: intFromString) int order,
    String folder,
    @JsonKey(fromJson: doubleFromString) double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    DateTime date,
    @JsonKey(name: 'file_size') String fileSize,
    List<String> samples,
  });
}

/// @nodoc
class __$$BookImplCopyWithImpl<$Res>
    extends _$BookCopyWithImpl<$Res, _$BookImpl>
    implements _$$BookImplCopyWith<$Res> {
  __$$BookImplCopyWithImpl(_$BookImpl _value, $Res Function(_$BookImpl) _then)
    : super(_value, _then);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lang = null,
    Object? series = freezed,
    Object? description = null,
    Object? rate = null,
    Object? downloads = null,
    Object? readings = freezed,
    Object? author = null,
    Object? illistrator = freezed,
    Object? publisher = null,
    Object? ageGroup = null,
    Object? cover = null,
    Object? file = null,
    Object? order = null,
    Object? folder = null,
    Object? version = null,
    Object? date = null,
    Object? fileSize = null,
    Object? samples = null,
  }) {
    return _then(
      _$BookImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        lang: null == lang
            ? _value.lang
            : lang // ignore: cast_nullable_to_non_nullable
                  as String,
        series: freezed == series
            ? _value.series
            : series // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        rate: null == rate
            ? _value.rate
            : rate // ignore: cast_nullable_to_non_nullable
                  as double,
        downloads: null == downloads
            ? _value.downloads
            : downloads // ignore: cast_nullable_to_non_nullable
                  as int,
        readings: freezed == readings
            ? _value.readings
            : readings // ignore: cast_nullable_to_non_nullable
                  as int?,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        illistrator: freezed == illistrator
            ? _value.illistrator
            : illistrator // ignore: cast_nullable_to_non_nullable
                  as String?,
        publisher: null == publisher
            ? _value.publisher
            : publisher // ignore: cast_nullable_to_non_nullable
                  as String,
        ageGroup: null == ageGroup
            ? _value.ageGroup
            : ageGroup // ignore: cast_nullable_to_non_nullable
                  as String,
        cover: null == cover
            ? _value.cover
            : cover // ignore: cast_nullable_to_non_nullable
                  as String,
        file: null == file
            ? _value.file
            : file // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        folder: null == folder
            ? _value.folder
            : folder // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as double,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fileSize: null == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as String,
        samples: null == samples
            ? _value._samples
            : samples // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookImpl extends _Book {
  const _$BookImpl({
    required this.id,
    required this.title,
    required this.lang,
    this.series,
    required this.description,
    @JsonKey(fromJson: doubleFromString) required this.rate,
    @JsonKey(fromJson: intFromString) required this.downloads,
    @JsonKey(fromJson: nullableIntFromString) this.readings,
    required this.author,
    this.illistrator,
    required this.publisher,
    @JsonKey(name: 'age_group') required this.ageGroup,
    required this.cover,
    required this.file,
    @JsonKey(fromJson: intFromString) required this.order,
    required this.folder,
    @JsonKey(fromJson: doubleFromString) required this.version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    required this.date,
    @JsonKey(name: 'file_size') required this.fileSize,
    final List<String> samples = const <String>[],
  }) : _samples = samples,
       super._();

  factory _$BookImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String lang;
  @override
  final String? series;
  @override
  final String description;
  @override
  @JsonKey(fromJson: doubleFromString)
  final double rate;
  @override
  @JsonKey(fromJson: intFromString)
  final int downloads;
  @override
  @JsonKey(fromJson: nullableIntFromString)
  final int? readings;
  @override
  final String author;
  @override
  final String? illistrator;
  @override
  final String publisher;
  @override
  @JsonKey(name: 'age_group')
  final String ageGroup;
  @override
  final String cover;
  @override
  final String file;
  @override
  @JsonKey(fromJson: intFromString)
  final int order;
  @override
  final String folder;
  @override
  @JsonKey(fromJson: doubleFromString)
  final double version;
  @override
  @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
  final DateTime date;
  @override
  @JsonKey(name: 'file_size')
  final String fileSize;
  final List<String> _samples;
  @override
  @JsonKey()
  List<String> get samples {
    if (_samples is EqualUnmodifiableListView) return _samples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_samples);
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, lang: $lang, series: $series, description: $description, rate: $rate, downloads: $downloads, readings: $readings, author: $author, illistrator: $illistrator, publisher: $publisher, ageGroup: $ageGroup, cover: $cover, file: $file, order: $order, folder: $folder, version: $version, date: $date, fileSize: $fileSize, samples: $samples)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.series, series) || other.series == series) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.downloads, downloads) ||
                other.downloads == downloads) &&
            (identical(other.readings, readings) ||
                other.readings == readings) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.illistrator, illistrator) ||
                other.illistrator == illistrator) &&
            (identical(other.publisher, publisher) ||
                other.publisher == publisher) &&
            (identical(other.ageGroup, ageGroup) ||
                other.ageGroup == ageGroup) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.folder, folder) || other.folder == folder) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            const DeepCollectionEquality().equals(other._samples, _samples));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    lang,
    series,
    description,
    rate,
    downloads,
    readings,
    author,
    illistrator,
    publisher,
    ageGroup,
    cover,
    file,
    order,
    folder,
    version,
    date,
    fileSize,
    const DeepCollectionEquality().hash(_samples),
  ]);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      __$$BookImplCopyWithImpl<_$BookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookImplToJson(this);
  }
}

abstract class _Book extends Book {
  const factory _Book({
    required final String id,
    required final String title,
    required final String lang,
    final String? series,
    required final String description,
    @JsonKey(fromJson: doubleFromString) required final double rate,
    @JsonKey(fromJson: intFromString) required final int downloads,
    @JsonKey(fromJson: nullableIntFromString) final int? readings,
    required final String author,
    final String? illistrator,
    required final String publisher,
    @JsonKey(name: 'age_group') required final String ageGroup,
    required final String cover,
    required final String file,
    @JsonKey(fromJson: intFromString) required final int order,
    required final String folder,
    @JsonKey(fromJson: doubleFromString) required final double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    required final DateTime date,
    @JsonKey(name: 'file_size') required final String fileSize,
    final List<String> samples,
  }) = _$BookImpl;
  const _Book._() : super._();

  factory _Book.fromJson(Map<String, dynamic> json) = _$BookImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get lang;
  @override
  String? get series;
  @override
  String get description;
  @override
  @JsonKey(fromJson: doubleFromString)
  double get rate;
  @override
  @JsonKey(fromJson: intFromString)
  int get downloads;
  @override
  @JsonKey(fromJson: nullableIntFromString)
  int? get readings;
  @override
  String get author;
  @override
  String? get illistrator;
  @override
  String get publisher;
  @override
  @JsonKey(name: 'age_group')
  String get ageGroup;
  @override
  String get cover;
  @override
  String get file;
  @override
  @JsonKey(fromJson: intFromString)
  int get order;
  @override
  String get folder;
  @override
  @JsonKey(fromJson: doubleFromString)
  double get version;
  @override
  @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
  DateTime get date;
  @override
  @JsonKey(name: 'file_size')
  String get fileSize;
  @override
  List<String> get samples;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

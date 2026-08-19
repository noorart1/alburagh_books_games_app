// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sound_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SoundBook _$SoundBookFromJson(Map<String, dynamic> json) {
  return _SoundBook.fromJson(json);
}

/// @nodoc
mixin _$SoundBook {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: nullableIntFromString)
  int? get readings => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
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

  /// Serializes this SoundBook to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SoundBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SoundBookCopyWith<SoundBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoundBookCopyWith<$Res> {
  factory $SoundBookCopyWith(SoundBook value, $Res Function(SoundBook) then) =
      _$SoundBookCopyWithImpl<$Res, SoundBook>;
  @useResult
  $Res call({
    String id,
    String title,
    String? lang,
    String? description,
    @JsonKey(fromJson: nullableIntFromString) int? readings,
    String image,
    String file,
    @JsonKey(fromJson: intFromString) int order,
    String folder,
    @JsonKey(fromJson: doubleFromString) double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    DateTime date,
    @JsonKey(name: 'file_size') String fileSize,
  });
}

/// @nodoc
class _$SoundBookCopyWithImpl<$Res, $Val extends SoundBook>
    implements $SoundBookCopyWith<$Res> {
  _$SoundBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SoundBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lang = freezed,
    Object? description = freezed,
    Object? readings = freezed,
    Object? image = null,
    Object? file = null,
    Object? order = null,
    Object? folder = null,
    Object? version = null,
    Object? date = null,
    Object? fileSize = null,
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
            lang: freezed == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            readings: freezed == readings
                ? _value.readings
                : readings // ignore: cast_nullable_to_non_nullable
                      as int?,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SoundBookImplCopyWith<$Res>
    implements $SoundBookCopyWith<$Res> {
  factory _$$SoundBookImplCopyWith(
    _$SoundBookImpl value,
    $Res Function(_$SoundBookImpl) then,
  ) = __$$SoundBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? lang,
    String? description,
    @JsonKey(fromJson: nullableIntFromString) int? readings,
    String image,
    String file,
    @JsonKey(fromJson: intFromString) int order,
    String folder,
    @JsonKey(fromJson: doubleFromString) double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    DateTime date,
    @JsonKey(name: 'file_size') String fileSize,
  });
}

/// @nodoc
class __$$SoundBookImplCopyWithImpl<$Res>
    extends _$SoundBookCopyWithImpl<$Res, _$SoundBookImpl>
    implements _$$SoundBookImplCopyWith<$Res> {
  __$$SoundBookImplCopyWithImpl(
    _$SoundBookImpl _value,
    $Res Function(_$SoundBookImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SoundBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lang = freezed,
    Object? description = freezed,
    Object? readings = freezed,
    Object? image = null,
    Object? file = null,
    Object? order = null,
    Object? folder = null,
    Object? version = null,
    Object? date = null,
    Object? fileSize = null,
  }) {
    return _then(
      _$SoundBookImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        lang: freezed == lang
            ? _value.lang
            : lang // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        readings: freezed == readings
            ? _value.readings
            : readings // ignore: cast_nullable_to_non_nullable
                  as int?,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SoundBookImpl extends _SoundBook {
  const _$SoundBookImpl({
    required this.id,
    required this.title,
    this.lang,
    this.description,
    @JsonKey(fromJson: nullableIntFromString) this.readings,
    required this.image,
    required this.file,
    @JsonKey(fromJson: intFromString) required this.order,
    required this.folder,
    @JsonKey(fromJson: doubleFromString) required this.version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    required this.date,
    @JsonKey(name: 'file_size') required this.fileSize,
  }) : super._();

  factory _$SoundBookImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoundBookImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? lang;
  @override
  final String? description;
  @override
  @JsonKey(fromJson: nullableIntFromString)
  final int? readings;
  @override
  final String image;
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

  @override
  String toString() {
    return 'SoundBook(id: $id, title: $title, lang: $lang, description: $description, readings: $readings, image: $image, file: $file, order: $order, folder: $folder, version: $version, date: $date, fileSize: $fileSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoundBookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.readings, readings) ||
                other.readings == readings) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.folder, folder) || other.folder == folder) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    lang,
    description,
    readings,
    image,
    file,
    order,
    folder,
    version,
    date,
    fileSize,
  );

  /// Create a copy of SoundBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SoundBookImplCopyWith<_$SoundBookImpl> get copyWith =>
      __$$SoundBookImplCopyWithImpl<_$SoundBookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoundBookImplToJson(this);
  }
}

abstract class _SoundBook extends SoundBook {
  const factory _SoundBook({
    required final String id,
    required final String title,
    final String? lang,
    final String? description,
    @JsonKey(fromJson: nullableIntFromString) final int? readings,
    required final String image,
    required final String file,
    @JsonKey(fromJson: intFromString) required final int order,
    required final String folder,
    @JsonKey(fromJson: doubleFromString) required final double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    required final DateTime date,
    @JsonKey(name: 'file_size') required final String fileSize,
  }) = _$SoundBookImpl;
  const _SoundBook._() : super._();

  factory _SoundBook.fromJson(Map<String, dynamic> json) =
      _$SoundBookImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get lang;
  @override
  String? get description;
  @override
  @JsonKey(fromJson: nullableIntFromString)
  int? get readings;
  @override
  String get image;
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

  /// Create a copy of SoundBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SoundBookImplCopyWith<_$SoundBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

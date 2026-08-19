// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Quran _$QuranFromJson(Map<String, dynamic> json) {
  return _Quran.fromJson(json);
}

/// @nodoc
mixin _$Quran {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;
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
  List<String> get samples => throw _privateConstructorUsedError;

  /// Serializes this Quran to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quran
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuranCopyWith<Quran> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuranCopyWith<$Res> {
  factory $QuranCopyWith(Quran value, $Res Function(Quran) then) =
      _$QuranCopyWithImpl<$Res, Quran>;
  @useResult
  $Res call({
    String id,
    String title,
    String lang,
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
    List<String> samples,
  });
}

/// @nodoc
class _$QuranCopyWithImpl<$Res, $Val extends Quran>
    implements $QuranCopyWith<$Res> {
  _$QuranCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quran
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lang = null,
    Object? description = freezed,
    Object? readings = freezed,
    Object? image = null,
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
abstract class _$$QuranImplCopyWith<$Res> implements $QuranCopyWith<$Res> {
  factory _$$QuranImplCopyWith(
    _$QuranImpl value,
    $Res Function(_$QuranImpl) then,
  ) = __$$QuranImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String lang,
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
    List<String> samples,
  });
}

/// @nodoc
class __$$QuranImplCopyWithImpl<$Res>
    extends _$QuranCopyWithImpl<$Res, _$QuranImpl>
    implements _$$QuranImplCopyWith<$Res> {
  __$$QuranImplCopyWithImpl(
    _$QuranImpl _value,
    $Res Function(_$QuranImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Quran
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lang = null,
    Object? description = freezed,
    Object? readings = freezed,
    Object? image = null,
    Object? file = null,
    Object? order = null,
    Object? folder = null,
    Object? version = null,
    Object? date = null,
    Object? fileSize = null,
    Object? samples = null,
  }) {
    return _then(
      _$QuranImpl(
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
class _$QuranImpl extends _Quran {
  const _$QuranImpl({
    required this.id,
    required this.title,
    required this.lang,
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
    final List<String> samples = const <String>[],
  }) : _samples = samples,
       super._();

  factory _$QuranImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuranImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String lang;
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
    return 'Quran(id: $id, title: $title, lang: $lang, description: $description, readings: $readings, image: $image, file: $file, order: $order, folder: $folder, version: $version, date: $date, fileSize: $fileSize, samples: $samples)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuranImpl &&
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
                other.fileSize == fileSize) &&
            const DeepCollectionEquality().equals(other._samples, _samples));
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
    const DeepCollectionEquality().hash(_samples),
  );

  /// Create a copy of Quran
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuranImplCopyWith<_$QuranImpl> get copyWith =>
      __$$QuranImplCopyWithImpl<_$QuranImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuranImplToJson(this);
  }
}

abstract class _Quran extends Quran {
  const factory _Quran({
    required final String id,
    required final String title,
    required final String lang,
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
    final List<String> samples,
  }) = _$QuranImpl;
  const _Quran._() : super._();

  factory _Quran.fromJson(Map<String, dynamic> json) = _$QuranImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get lang;
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
  @override
  List<String> get samples;

  /// Create a copy of Quran
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuranImplCopyWith<_$QuranImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

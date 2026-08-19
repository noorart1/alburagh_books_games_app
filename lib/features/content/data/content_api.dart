import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/content_list_response.dart';

/// Thin wrapper over the content-related endpoints traced from
/// `Helpers/WebService.java`. Response envelopes are inconsistent in the
/// original API (some endpoints return `{success:1,...}`, `content_list`
/// returns a raw object) — that's reflected here rather than normalized
/// away, so callers see exactly what the server sends.
class ContentApi {
  ContentApi(this._dio);

  final Dio _dio;

  Future<ContentListResponse> getContentList() async {
    // The server mislabels this endpoint as `text/html`, so Dio's
    // auto-JSON-decoding (which keys off the content-type header) skips it
    // and hands back a raw string — decode it ourselves instead.
    final response = await _dio.get<String>(
      '/content_list',
      options: Options(responseType: ResponseType.plain),
    );
    return ContentListResponse.fromJson(jsonDecode(response.data!) as Map<String, dynamic>);
  }

  /// `GET /rate/{contentID}/{rate}` — rate is sent as a `%.1f`-formatted string.
  Future<void> rateContent(String contentId, double rate) async {
    await _dio.get('/rate/$contentId/${rate.toStringAsFixed(1)}');
  }

  /// `GET /increase_readings/{contentID}` — fired when a content item is opened.
  Future<void> increaseReadings(String contentId) async {
    await _dio.get('/increase_readings/$contentId');
  }

  /// `GET /increase_download/{contentID}` — fired after a successful download.
  Future<void> increaseDownloads(String contentId) async {
    await _dio.get('/increase_download/$contentId');
  }
}

final contentApiProvider = Provider<ContentApi>((ref) => ContentApi(ref.watch(dioProvider)));

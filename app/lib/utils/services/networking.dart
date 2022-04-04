import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:metafy_app/exceptions/invalid_data_exception.dart';
import 'package:metafy_app/utils/services/env.dart';
import 'package:metafy_app/utils/services/shared_preferences.dart';

enum ImageScope { cover, profile }

class Api {
  static String cdnAsset(String asset) {
    final cdnUrl = Env.cdnUrl;

    return '$cdnUrl/$asset';
  }

  static String get _basePath {
    return '/api/';
  }

  static String get authority {
    return (kReleaseMode ? Env.apiAuthorityProd : Env.apiAuthorityDev) ?? '';
  }

  static Future<Map<String, String>> _getHeaders() async {
    final authorization = await Prefs.getAuthorization();

    return {
      HttpHeaders.authorizationHeader: authorization ?? '',
    };
  }

  // helpers

  static void _logInfo({required http.Response response}) {
    if (kDebugMode) {
      final path = response.request?.url.path;

      print(
        '$path ${((response.contentLength ?? 0) / 1000).toStringAsFixed(2)}KB',
      );

      print(response.headers);

      print(response.body);
    }
  }

  static void _logMultipartInfo({
    required http.StreamedResponse response,
    required String path,
    required String uri,
    required dynamic body,
  }) {
    if (kDebugMode) {
      print(
          '$path$uri ${((response.contentLength ?? 0) / 1000).toStringAsFixed(2)}KB');
      print(response.headers);
      print(body);
    }
  }

  static Future get(String uri, Map<String, String> query) async {
    final response = await http.get(
      kReleaseMode
          ? Uri.https(authority, '$_basePath$uri', query)
          : Uri.http(authority, '$_basePath$uri', query),
      headers: await _getHeaders(),
    );

    _logInfo(response: response);

    final incomingAuthorization = response.headers['authorization'];

    if (incomingAuthorization != null) {
      await Prefs.setAuthorization(incomingAuthorization);
    }

    if (response.statusCode >= 299) {
      throw InvalidDataException(jsonDecode(response.body)['message']);
    }

    return jsonDecode(response.body);
  }

  static Future post(String uri, Map<String, String> body) async {
    final response = await http.post(
      kReleaseMode
          ? Uri.https(authority, '$_basePath$uri')
          : Uri.http(authority, '$_basePath$uri'),
      headers: await _getHeaders(),
      body: body,
    );

    _logInfo(response: response);

    final incomingAuthorization = response.headers['authorization'];

    if (incomingAuthorization != null) {
      await Prefs.setAuthorization(incomingAuthorization);
    }

    if (response.statusCode >= 299) {
      throw InvalidDataException(jsonDecode(response.body)['message']);
    }

    return jsonDecode(response.body);
  }

  static Future multipart(String uri, ImageScope scope, String path) async {
    final request = http.MultipartRequest(
      'POST',
      kReleaseMode
          ? Uri.https(authority, '$_basePath$uri')
          : Uri.http(authority, '$_basePath$uri'),
    );

    request.headers.addAll(await _getHeaders());
    request.files.add(await http.MultipartFile.fromPath('image', path));
    request.fields.addAll({
      'scope': scope.toString().replaceAll(RegExp(r'^\w+.'), ''),
    });

    final response = await request.send();
    final body = await response.stream.bytesToString();

    _logMultipartInfo(
      response: response,
      path: _basePath,
      uri: uri,
      body: body,
    );

    final incomingAuthorization = response.headers['authorization'];

    if (incomingAuthorization != null) {
      await Prefs.setAuthorization(incomingAuthorization);
    }

    if (response.statusCode >= 299) {
      throw InvalidDataException(jsonDecode(body)['message']);
    }

    return jsonDecode(body);
  }
}

library repo;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'enums.dart';

export 'enums.dart';

/// A class responsible for handling basic operations and interactions
/// with the remote repository.
class Repo {
  /// A method that returns a `String` value representing the basic authentication
  String basicAuth(String credentials) =>
      'Basic ${base64Encode(utf8.encode(credentials))}';

  /// A map representing the base headers to be sent with the request
  final Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// A method that makes a request to the remote repository.
  /// The method accepts the following parameters:
  /// - `url` - a `String` representing the URL to which the request will be made.
  /// - `method` - a `RequestMethod` enum value representing the HTTP method to be used.
  /// - `headers` - an optional `Map<String, String>` representing the headers to be sent with the request.
  /// - `body` - an optional dynamic value representing the body of the request.
  /// - `encoding` - an optional `Encoding` value representing the encoding to be used.
  /// - `timeout` - an optional `int` value representing the timeout for the request.
  /// The method returns a `Future<http.Response>` value.
  Future<http.Response> call(
    String url, {
    RequestMethod method = RequestMethod.get,
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
    int timeout = 7,
  }) async {
    http.Response response;
    var newBody = jsonEncode(body);
    var newEncoding = encoding ?? Encoding.getByName('utf-8');

    checkValidHeaders(headers);

    try {
      switch (method) {
        case RequestMethod.get:
          response = await http.Client().get(
            Uri.parse(url),
            headers: {
              ..._baseHeaders,
              if (headers != null) ...headers,
            },
          ).timeout(Duration(seconds: timeout));
          break;
        case RequestMethod.post:
          response = await http.Client()
              .post(
                Uri.parse(url),
                headers: {
                  ..._baseHeaders,
                  if (headers != null) ...headers,
                },
                body: newBody,
                encoding: newEncoding,
              )
              .timeout(Duration(seconds: timeout));
          break;
        case RequestMethod.put:
          response = await http.Client()
              .put(
                Uri.parse(url),
                headers: {
                  ..._baseHeaders,
                  if (headers != null) ...headers,
                },
                body: newBody,
                encoding: newEncoding,
              )
              .timeout(Duration(seconds: timeout));
          break;
        case RequestMethod.delete:
          response = await http.Client().delete(
            Uri.parse(url),
            headers: {
              ..._baseHeaders,
              if (headers != null) ...headers,
            },
          ).timeout(Duration(seconds: timeout));
          break;
        default:
          throw Exception('Invalid method');
      }
    } catch (e) {
      throw Exception('Failed to make request: $e');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        break;
      case 400:
        throw Exception('Bad request: ${response.statusCode}');
      case 401:
        throw Exception('Unauthorized: ${response.statusCode}');
      case 403:
        throw Exception('Forbidden: ${response.statusCode}');
      case 404:
        throw Exception('Not found: ${response.statusCode}');
      case 500:
        throw Exception('Internal server error: ${response.statusCode}');
      default:
        throw Exception('Failed to make request: ${response.statusCode}');
    }

    return response;
  }

  void checkValidHeaders(Map<String, String>? headers) {
    if (headers != null) {
      headers.forEach((key, value) {
        if (key.isEmpty || value.isEmpty) {
          throw Exception('Invalid headers');
        }

        if (key.toLowerCase() == 'content-type' ||
            key.toLowerCase() == 'accept') {
          throw Exception('Invalid headers');
        }

        if (key.toLowerCase() == 'authorization') {
          if (!value.contains(' ')) {
            throw Exception('Invalid headers');
          }
        }
      });
    }
  }
}

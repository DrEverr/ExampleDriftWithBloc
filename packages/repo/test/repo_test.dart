import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:repo/repo.dart';

void main() {
  test('basic authorization creation', () {
    final repo = Repo();
    expect(
        repo.basicAuth('username:password'), 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=');
    expect(repo.basicAuth('admin:admin'), 'Basic YWRtaW46YWRtaW4=');
  });

  test('request method get', () async {
    final repo = Repo();
    final response =
        await repo.call('https://jsonplaceholder.typicode.com/posts/1');
    expect(response.statusCode, 200);
  });

  test('request method post', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts',
      method: RequestMethod.post,
      body: {
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      },
    );
    expect(response.statusCode, 201);
  });

  test('request method put', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts/1',
      method: RequestMethod.put,
      body: {
        'id': 1,
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      },
    );
    expect(response.statusCode, 200);
  });

  test('request method delete', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts/1',
      method: RequestMethod.delete,
    );
    expect(response.statusCode, 200);
  });

  test('request method with headers', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts/1',
      headers: {
        'Authorization': repo.basicAuth('username:password'),
      },
    );
    expect(response.statusCode, 200);
  });

  test('request method with timeout', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts/1',
      timeout: 1,
    );
    expect(response.statusCode, 200);
  });

  test('request method with encoding', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts/1',
      encoding: Encoding.getByName('utf-8'),
    );
    expect(response.statusCode, 200);
  });

  test('request method with invalid url', () async {
    final repo = Repo();
    expect(
      () => repo.call('https://jsonplaceholder.typicode.com/posts/1/invalid'),
      throwsException,
    );
  });

  test('request method with invalid body', () async {
    final repo = Repo();
    expect(
      () => repo.call(
        'https://jsonplaceholder.typicode.com/posts',
        method: RequestMethod.post,
        body: 'invalid',
      ),
      throwsException,
    );
  });

  /// Instead of invalid encoding, we will use a default encoding
  test('request method with invalid encoding', () async {
    final repo = Repo();
    final response = await repo.call(
      'https://jsonplaceholder.typicode.com/posts/1',
      encoding: Encoding.getByName('utf-16'),
    );
    expect(response.statusCode, 200);
  });

  test('request method with invalid timeout', () async {
    final repo = Repo();
    expect(
      () => repo.call(
        'https://jsonplaceholder.typicode.com/posts/1',
        timeout: -1,
      ),
      throwsException,
    );
  });

  test('request method with invalid headers', () async {
    final repo = Repo();
    expect(
      () => repo.call(
        'https://jsonplaceholder.typicode.com/posts/1',
        headers: {
          'Authorization': 'invalid',
        },
      ),
      throwsException,
    );
  });

  test('request method with invalid response', () async {
    final repo = Repo();
    expect(
      repo.call('https://jsonplaceholder.typicode.com/posts/invalid'),
      throwsException,
    );
  });
}

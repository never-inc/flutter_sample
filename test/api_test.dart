import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

abstract class ReqBase {
  String get baseUrl;
  String get path;
}

final class GetGithubUsersReq extends ReqBase {
  @override
  String get baseUrl => 'api.github.com';

  @override
  String get path => 'users';
}

final class GetGithubUserReq extends ReqBase {
  GetGithubUserReq({
    required this.username,
  });

  final String username;

  @override
  String get baseUrl => 'api.github.com';

  @override
  String get path => 'users/$username';
}

/// apiメソッド
Future<http.Response> api(ReqBase req) async {
  try {
    final res = await http.get(
      Uri.https(req.baseUrl, req.path),
    );

    return res;
  } on Exception catch (e) {
    throw AppException.error('エラーが発生しました: $e');
  }
}

void main() {
  group('抽象化クラスのテスト', () {
    test(
      'テスト1',
      () async {
        /// 実行
        final res1 = await api(GetGithubUsersReq());
        debugPrint(res1.body);

        final res2 = await api(GetGithubUserReq(username: 'hukusuke1007'));
        debugPrint(res2.body);
      },
    );
  });
}

import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("POST /register returns 400 with invalid JSON request", () async {
    final response = await harness.agent
        .post('/register', body: {"username": "", "password": null});
    expectResponse(response, 400,
        body: {"error": "usernaame and password are required"});
  });

  test("POST /register returns 200 with valid JSON request", () async {
    final response = await harness.agent
        .post('/register', body: {'username': 'test', 'password': 'password'});
    expectResponse(response, 200, body: {'id': 1, 'username': 'test'});
  });
}

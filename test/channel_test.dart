import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /example returns 200 'pong'", () async {
    expectResponse(await harness.agent.get("/ping"), 200, body: "pong");
  });
}

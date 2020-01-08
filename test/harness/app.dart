import 'package:api/api.dart';
import 'package:api/model/user.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:api/api.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

class Harness extends TestHarness<ApiChannel>
    with TestHarnessORMMixin, TestHarnessAuthMixin<ApiChannel> {
  @override
  ManagedContext get context => channel.context;

  @override
  AuthServer get authServer => channel.authServer;

  Agent publicAgent;

  @override
  Future onSetUp() async {
    await resetData();
    publicAgent = await addClient('com.kevingenus.dev');
  }

  @override
  Future onTearDown() async {}

  Future<Agent> registerUser(User user, {Agent withClient}) async {
    withClient ??= publicAgent;

    final request = withClient.request('/register')
      ..body = {'username': user.username, 'password': user.password};
    await request.post();
    return loginUser(withClient, user.username, user.password);
  }
}

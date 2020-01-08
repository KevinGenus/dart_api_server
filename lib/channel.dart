import 'package:aqueduct/managed_auth.dart';

import 'api.dart';
import 'controller/register.dart';
import 'model/user.dart';

class ApiConfiguration extends Configuration {
  ApiConfiguration(String configPath) : super.fromFile(File(configPath));

  DatabaseConfiguration database;
}

class ApiChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  @override
  Future prepare() async {
    final config = ApiConfiguration(options.configurationFilePath);

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName,
    );
    context = ManagedContext(dataModel, psc);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);

    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/ping').linkFunction((request) async {
      return Response.ok('pong');
    });

    router.route('/auth/token').link(() => AuthController(authServer));

    router
        .route('/register')
        .link(() => RegisterController(context, authServer));

    return router;
  }
}

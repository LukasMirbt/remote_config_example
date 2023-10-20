import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:remote_config_example/app/view/app.dart';
import 'package:remote_config_repository/models/remote_config_service.dart';
import 'package:remote_config_repository/remote_config_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseApp = await Firebase.initializeApp(
      // TODO(User): Configure Firebase with CLI
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  final remoteConfigRepository = RemoteConfigRepository(
    firebaseApp,
    RemoteConfigService(FirebaseRemoteConfig.instance),
  );

  runApp(
    App(
      remoteConfigRepository: remoteConfigRepository,
    ),
  );
}

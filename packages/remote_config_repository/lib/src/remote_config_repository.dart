import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:remote_config_repository/models/config.dart';
import 'package:remote_config_repository/models/remote_config_service.dart';

class RemoteConfigRepository {
  RemoteConfigRepository(
    FirebaseApp _,
    RemoteConfigService remoteConfigService,
  ) : _remoteConfigService = remoteConfigService;

  final RemoteConfigService _remoteConfigService;

  Stream<Config> get config => _remoteConfigService.config;
  Config get currentConfig => _remoteConfigService.currentConfig;

  Future<void> initialize() async {
    await _remoteConfigService.setDefaults();
    await _remoteConfigService.fetchAndActivate();
    _remoteConfigService.subscribe();
  }
}

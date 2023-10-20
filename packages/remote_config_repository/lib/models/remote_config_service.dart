import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_config_repository/models/config.dart';

class RemoteConfigService {
  RemoteConfigService(
    FirebaseRemoteConfig remoteConfig,
  ) : _remoteConfig = remoteConfig;

  final FirebaseRemoteConfig _remoteConfig;

  final _controller = StreamController<Config>.broadcast();
  Stream<Config> get config => _controller.stream;

  Config? _currentConfig;
  Config get currentConfig => _currentConfig ?? Config.defaults;

  Future<void> _updateConfig() async {
    await _remoteConfig.activate();
    final keys = _remoteConfig.getAll();
    final config = Config.fromRemoteConfig(keys);
    _currentConfig = config;
    _controller.add(config);
  }

  Future<void> setDefaults() async {
    await _remoteConfig.setDefaults(Config.defaults.toJson());
  }

  Future<void> fetchAndActivate() async {
    await _remoteConfig.ensureInitialized();
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(minutes: 5),
      ),
    );

    await _remoteConfig.fetch();
    await _updateConfig();
  }

  void subscribe() {
    _remoteConfig.onConfigUpdated.listen((event) {
      _updateConfig();
    });
  }
}

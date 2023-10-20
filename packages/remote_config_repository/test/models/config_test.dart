// ignore_for_file: prefer_const_constructors

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_config_repository/models/config.dart';

class MockRemoteConfigInt extends Mock implements RemoteConfigValue {
  @override
  int asInt() => 1;
}

class MockRemoteConfigBool extends Mock implements RemoteConfigValue {
  @override
  bool asBool() => true;
}

void main() {
  group('Config', () {
    test('can (de)serialize', () {
      final config = Config.fromRemoteConfig({
        'counter_value': MockRemoteConfigInt(),
        'show_decrement_button': MockRemoteConfigBool(),
      });

      expect(
        config,
        Config(counterValue: 1),
      );
    });
  });
}

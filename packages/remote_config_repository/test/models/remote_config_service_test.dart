// ignore_for_file: prefer_const_constructors, cascade_invocations

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_config_repository/models/models.dart';

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class MockRemoteConfigInt extends Mock implements RemoteConfigValue {
  @override
  int asInt() => 1;
}

void main() {
  group('RemoteConfigService', () {
    late FirebaseRemoteConfig firebaseRemoteConfig;

    setUp(() {
      firebaseRemoteConfig = MockFirebaseRemoteConfig();
      when(() => firebaseRemoteConfig.activate()).thenAnswer(
        (_) async => true,
      );
      when(() => firebaseRemoteConfig.getAll()).thenAnswer(
        (_) => {},
      );
    });

    RemoteConfigService createSubject() {
      return RemoteConfigService(
        firebaseRemoteConfig,
      );
    }

    group('constructor', () {
      test('initializes _remoteConfig', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('setDefaults', () {
      test('calls FirebaseRemoteConfig.setDefaults', () async {
        final defaultValues = Config.defaults.toJson();

        when(() => firebaseRemoteConfig.setDefaults(defaultValues)).thenAnswer(
          (_) async {},
        );

        final remoteConfigService = createSubject();

        await remoteConfigService.setDefaults();

        verify(
          () => firebaseRemoteConfig.setDefaults(defaultValues),
        ).called(1);
      });
    });

    group('fetchAndActivate', () {
      test('ensureInitialized, setConfigSettings, fetchAndActivate', () async {
        registerFallbackValue(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 5),
            minimumFetchInterval: const Duration(minutes: 5),
          ),
        );

        when(() => firebaseRemoteConfig.ensureInitialized()).thenAnswer(
          (_) async {},
        );
        when(() => firebaseRemoteConfig.setConfigSettings(any())).thenAnswer(
          (_) async {},
        );
        when(() => firebaseRemoteConfig.fetch()).thenAnswer(
          (_) async {},
        );

        final remoteConfigService = createSubject();

        await remoteConfigService.fetchAndActivate();

        verify(
          () => firebaseRemoteConfig.ensureInitialized(),
        ).called(1);
        verify(
          () => firebaseRemoteConfig.setConfigSettings(any()),
        ).called(1);
        verify(
          () => firebaseRemoteConfig.fetch(),
        ).called(1);
      });
    });

    group('subscribe', () {
      test('adds onConfigUpdated listener', () async {
        when(() => firebaseRemoteConfig.onConfigUpdated).thenAnswer(
          (_) => const Stream.empty(),
        );
        final remoteConfigService = createSubject();

        remoteConfigService.subscribe();

        verify(
          () => firebaseRemoteConfig.onConfigUpdated.listen(any()),
        ).called(1);
      });
    });

    group('config', () {
      test('emits config when remote config changes', () async {
        final update = RemoteConfigUpdate({
          'counter_value',
        });
        when(() => firebaseRemoteConfig.onConfigUpdated).thenAnswer(
          (_) => Stream.value(update),
        );
        when(() => firebaseRemoteConfig.activate()).thenAnswer(
          (_) async => true,
        );
        when(() => firebaseRemoteConfig.getAll()).thenAnswer(
          (_) => {
            'counter_value': MockRemoteConfigInt(),
          },
        );
        final service = createSubject();

        service.subscribe();

        await expectLater(
          service.config,
          emitsInOrder(
            [
              Config(counterValue: 1),
            ],
          ),
        );

        verify(() => firebaseRemoteConfig.activate()).called(1);
        verify(() => firebaseRemoteConfig.getAll()).called(1);
      });
    });
    group('currentConfig', () {
      test('returns default values when config is null', () async {
        final service = createSubject();

        expect(service.currentConfig, Config.defaults);
      });

      test('updates currentConfig when remote config changes', () async {
        final update = RemoteConfigUpdate({
          'counter_value',
        });
        when(() => firebaseRemoteConfig.onConfigUpdated).thenAnswer(
          (_) => Stream.value(update),
        );
        when(() => firebaseRemoteConfig.activate()).thenAnswer(
          (_) async => true,
        );
        when(() => firebaseRemoteConfig.getAll()).thenAnswer(
          (_) => {
            'counter_value': MockRemoteConfigInt(),
          },
        );
        final service = createSubject();
        service.subscribe();

        await expectLater(
          service.config,
          emitsInOrder(
            [
              Config(counterValue: 1),
            ],
          ),
        );

        await expectLater(
          service.currentConfig,
          Config(counterValue: 1),
        );

        verify(() => firebaseRemoteConfig.activate()).called(1);
        verify(() => firebaseRemoteConfig.getAll()).called(1);
      });
    });
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_config_repository/models/models.dart';
import 'package:remote_config_repository/remote_config_repository.dart';

class MockRemoteConfigService extends Mock implements RemoteConfigService {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  group('RemoteConfigRepository', () {
    late RemoteConfigService remoteConfigService;
    late FirebaseApp firebaseApp;

    setUp(() {
      remoteConfigService = MockRemoteConfigService();
      firebaseApp = MockFirebaseApp();
    });

    RemoteConfigRepository createSubject() {
      return RemoteConfigRepository(
        firebaseApp,
        remoteConfigService,
      );
    }

    group('config', () {
      test('returns RemoteConfigService.config', () {
        when(() => remoteConfigService.config).thenAnswer(
          (_) => const Stream.empty(),
        );

        final repository = createSubject();

        expect(
          repository.config,
          remoteConfigService.config,
        );
      });
    });

    group('currentConfig', () {
      test('returns RemoteConfigService.currentConfig', () {
        when(() => remoteConfigService.currentConfig).thenAnswer(
          (_) => Config.defaults,
        );

        final repository = createSubject();

        expect(
          repository.currentConfig,
          Config.defaults,
        );
      });
    });

    group('initialize', () {
      test(
          'calls RemoteConfigService methods, '
          'setDefault, fetchAndActivate and subscribe', () async {
        when(remoteConfigService.setDefaults).thenAnswer(
          (_) async {
            return;
          },
        );
        when(remoteConfigService.fetchAndActivate).thenAnswer(
          (_) async {
            return;
          },
        );
        when(remoteConfigService.subscribe).thenAnswer(
          (_) async {
            return;
          },
        );

        final repository = createSubject();

        await repository.initialize();

        verify(
          remoteConfigService.setDefaults,
        ).called(1);

        verify(
          remoteConfigService.fetchAndActivate,
        ).called(1);

        verify(
          remoteConfigService.subscribe,
        ).called(1);
      });
    });
  });
}

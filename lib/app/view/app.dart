import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_config_example/counter/view/counter_page.dart';
import 'package:remote_config_repository/remote_config_repository.dart';

class App extends StatelessWidget {
  const App({
    required RemoteConfigRepository remoteConfigRepository,
    super.key,
  }) : _remoteConfigRepository = remoteConfigRepository;

  final RemoteConfigRepository _remoteConfigRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _remoteConfigRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (_) => CounterPage.route(),
    );
  }
}

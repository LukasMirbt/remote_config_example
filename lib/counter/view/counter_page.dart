import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_config_example/counter/bloc/counter_bloc.dart';
import 'package:remote_config_repository/remote_config_repository.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => CounterBloc(
          context.read<RemoteConfigRepository>(),
        ),
        child: const CounterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: const Column(
        children: [
          _Text(),
        ],
      ),
      floatingActionButton: const _Fabs(),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    final count = context.select(
      (CounterBloc bloc) => bloc.state.count,
    );

    final theme = Theme.of(context);

    return Text(
      '$count',
      style: theme.textTheme.displayLarge,
    );
  }
}

class _Fabs extends StatelessWidget {
  const _Fabs();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            context.read<CounterBloc>().add(
                  const CounterIncrementPressed(),
                );
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () {
            context.read<CounterBloc>().add(
                  const CounterDecrementPressed(),
                );
          },
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}

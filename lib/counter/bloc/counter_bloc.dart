import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_config_example/counter/bloc/counter_state.dart';
import 'package:remote_config_repository/models/config.dart';
import 'package:remote_config_repository/remote_config_repository.dart';

part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(this._remoteConfigRepository)
      : super(
          CounterState(
            count: _remoteConfigRepository.currentConfig.counterValue,
          ),
        ) {
    on<_CounterConfigChanged>(_onCounterConfigChanged);
    on<CounterIncrementPressed>(_onIncrementPressed);
    on<CounterDecrementPressed>(_onDecrementPressed);

    _subscription = _remoteConfigRepository.config.listen(
      (config) {
        add(
          _CounterConfigChanged(config.counterValue),
        );
      },
    );
  }

  late StreamSubscription<Config> _subscription;
  final RemoteConfigRepository _remoteConfigRepository;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onCounterConfigChanged(
    _CounterConfigChanged event,
    Emitter<CounterState> emit,
  ) {
    emit(
      state.copyWith(
        count: event.count,
      ),
    );
  }

  void _onIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(
      state.copyWith(
        count: state.count + 1,
      ),
    );
  }

  void _onDecrementPressed(
    CounterDecrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(
      state.copyWith(
        count: state.count - 1,
      ),
    );
  }
}

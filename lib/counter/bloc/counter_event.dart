part of 'counter_bloc.dart';

sealed class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

final class _CounterConfigChanged extends CounterEvent {
  const _CounterConfigChanged(this.count);

  final int count;

  @override
  List<Object> get props => [count];
}

final class CounterIncrementPressed extends CounterEvent {
  const CounterIncrementPressed();
}

final class CounterDecrementPressed extends CounterEvent {
  const CounterDecrementPressed();
}

import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Config extends Equatable {
  const Config({
    required this.counterValue,
  });

  factory Config.fromRemoteConfig(Map<String, RemoteConfigValue> json) {
    return Config(
      counterValue: json['counter_value']?.asInt() ?? defaults.counterValue,
    );
  }

  final int counterValue;

  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  static const defaults = Config(
    counterValue: 1,
  );

  @override
  List<Object?> get props => [counterValue];
}

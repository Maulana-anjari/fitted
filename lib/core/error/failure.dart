import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  final int? statusCode;
  const NetworkFailure({required String message, this.statusCode})
      : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required String message, this.statusCode})
      : super(message: message);
}

class AiServiceFailure extends Failure {
  const AiServiceFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

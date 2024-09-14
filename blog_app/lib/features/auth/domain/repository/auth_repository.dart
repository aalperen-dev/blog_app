import 'package:blog_app/core/error/app_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<AppFailure, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<AppFailure, String>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

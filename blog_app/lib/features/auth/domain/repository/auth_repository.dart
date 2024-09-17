import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<AppFailure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserEntity>> currentUser();
}

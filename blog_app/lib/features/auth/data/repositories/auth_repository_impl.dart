import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/app_exceptions.dart';
import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<AppFailure, UserEntity>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return Left(AppFailure('User not logged in!'));
        }

        return Right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: 'name',
          ),
        );
      }

      final currentUser = await remoteDataSource.getCurrentUserData();

      if (currentUser == null) {
        return Left(AppFailure('User not logged in!'));
      }
      return Right(currentUser);
    } on AppException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<AppFailure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signupWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<AppFailure, UserEntity>> _getUser(
    Future<UserEntity> Function() fn,
  ) async {
    try {
      // bağlantı kontrol
      if (!await (connectionChecker.isConnected)) {
        return Left(AppFailure(AppConstants.noConnectionsErrorMsg));
      }

      final user = await fn();

      return Right(user);
    } on AppException catch (e) {
      return Left(AppFailure(e.message));
    }
  }
}

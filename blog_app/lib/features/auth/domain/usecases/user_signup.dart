import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/core/usecase/usecases.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<UserEntity, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);
  @override
  Future<Either<AppFailure, UserEntity>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams(
      {required this.email, required this.password, required this.name});
}

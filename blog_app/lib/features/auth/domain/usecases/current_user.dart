import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/core/usecase/usecases.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);
  @override
  Future<Either<AppFailure, UserEntity>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}

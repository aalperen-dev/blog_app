import 'package:blog_app/core/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<AppFailure, SuccessType>> call(Params params);
}

class NoParams {}

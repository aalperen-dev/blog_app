import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/core/usecase/usecases.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entitiy.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<BlogEntitiy>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<AppFailure, List<BlogEntitiy>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}

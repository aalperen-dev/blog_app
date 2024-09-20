import 'dart:io';

import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entitiy.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<AppFailure, BlogEntitiy>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<AppFailure, List<BlogEntitiy>>> getAllBlogs();
}

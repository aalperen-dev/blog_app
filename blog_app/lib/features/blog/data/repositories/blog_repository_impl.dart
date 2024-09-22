import 'dart:io';

import 'package:blog_app/core/error/app_exceptions.dart';
import 'package:blog_app/core/error/app_failures.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entitiy.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  // final BlogLocalDataSource blogLocalDataSource;
  // final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    // this.blogLocalDataSource,
    // this.connectionChecker,
  );

  @override
  Future<Either<AppFailure, BlogEntitiy>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      // if (!await (connectionChecker.isConnected)) {
      //   return left(AppFailure(Constants.noConnectionErrorMessage));
      // }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return Right(uploadedBlog);
    } on AppException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<AppFailure, List<BlogEntitiy>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs();

      return Right(blogs);
    } on AppException catch (e) {
      return Left(AppFailure(e.message));
    }
  }
}

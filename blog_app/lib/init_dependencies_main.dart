part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

class AppDependencies {
  static Future<void> initDependencies() async {
    _initAuth();
    _initBlog();
    final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnonKey,
    );

    Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

    serviceLocator.registerLazySingleton(
      () => supabase.client,
    );
    serviceLocator.registerLazySingleton(
      () => Hive.box(name: 'blogs'),
    );
    serviceLocator.registerFactory(
      () => InternetConnection(),
    );
    // core
    serviceLocator.registerLazySingleton(
      () => AppUserCubit(),
    );
    serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()),
    );
  }
}

void _initAuth() {
  serviceLocator
    // data source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(
      () => UserSignUp(serviceLocator()),
    )
    ..registerFactory(
      () => UserLogin(serviceLocator()),
    )
    ..registerFactory(
      () => CurrentUser(serviceLocator()),
    )
    // bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // data source
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // usecases
    ..registerFactory(
      () => UploadBlog(serviceLocator()),
    )
    ..registerFactory(
      () => GetAllBlogs(serviceLocator()),
    )
    // bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}

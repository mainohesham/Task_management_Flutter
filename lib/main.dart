import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'features/auth/model/repository/auth_repository.dart';
import 'features/auth/model/service/auth_api_service.dart';
import 'features/auth/model/service/auth_service.dart';
import 'features/auth/view/screens/signup/signup.dart';
import 'features/auth/view_model/cubit/auth_cubit.dart';
import 'features/profile/view_model/cubit/profile_cubit.dart';
import 'features/tasks/model/repository/task_repository.dart';
import 'features/tasks/model/service/task_api_service.dart';
import 'features/tasks/model/service/task_service.dart';
import 'features/tasks/view_model/cubit/task_cubit.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //sevices
    final authService = AuthService();
    final taskService = TaskDatabaseService();
    final authApiService = AuthApiService();
    final taskApiSevice = TaskApiService();


    final authRepo = AuthRepository(authService, authApiService);

    final taskRepo = TaskRepository(taskService, taskApiSevice );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit(authRepo)),
        BlocProvider<TaskCubit>(create: (context) => TaskCubit(taskRepo)),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit(authRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        home: Signup(),
      ),
    );
  }
}

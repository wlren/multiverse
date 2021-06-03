//Packages
// ignore: import_of_legacy_library_into_null_safe
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//Local Files
import '../amplifyconfiguration.dart';
import '../app_navigator.dart';
import '../classes/theme_data.dart';
import '../models/model_prodiver.dart';
import '../repository/auth_repository.dart';
import '../repository/data_repository.dart';
import '../repository/dining_repository.dart';
import '../repository/user_repository.dart';
import '../screens/loading_screen.dart';
import '../session_cubit.dart';
import '../view_model/dining_model.dart';
import '../view_model/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  //Configure AWS Amplify
  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(),
      ]);

      await Amplify.configure(amplifyconfig);
      setState(() {
        _isAmplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Providers inject dependencies into the app. Placed outside MaterialApp
    // to allow any screen to use this information.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => DiningRepository()),
        RepositoryProvider(create: (context) => DataRepository()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => UserModel(context.read<UserRepository>())),
          ChangeNotifierProvider(
            create: (context) => DiningModel(context.read<DiningRepository>()),
          ),
          BlocProvider(
            create: (context) => SessionCubit(
                authRepository: context.read<AuthRepository>(),
                dataRepo: context.read<DataRepository>()),
          )
        ],
        child: MaterialApp(
          title: 'Multiverse',
          theme: ThemeDataMultiverse.lightThemeData,
          darkTheme: ThemeDataMultiverse.darkThemeData,
          themeMode: ThemeMode.system,
          home: _isAmplifyConfigured
              ? const AppNavigator()
              : const LoadingScreen(),
          debugShowCheckedModeBanner: false, // Hide debug flag
        ),
      ),
    );
  }
}

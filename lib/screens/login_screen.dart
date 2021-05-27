import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../auth/auth_repository.dart';
import '../auth/form_submission_status.dart';
import '../auth/login/login_bloc.dart';
import '../auth/login/login_event.dart';
import '../auth/login/login_state.dart';
import '../view_model/user_model.dart';
import '../user_repository.dart';
import 'dashboard_screen.dart';

///The initial screen which user would see upon launching app
///prompts user to log in and will authenticate using AWS Amplify
///Authentication services
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  //Allows form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Show snackbar on failed login
  void _showSnackBarOnFail(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /* WIDGETS start*/

  //NUS NetID username widget
  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'NUSNet ID',
        ),
        //Validation check
        validator: (value) {
          return state.isValidUsername
              ? null
              : "Please enter NUSNet ID (exxxxxxx)";
        },
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginUsernameChanged(username: value),
            ),
      );
    });
  }

  //Password field widget
  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        //Validation check
        validator: (value) {
          return state.isValidPassword ? null : "Please enter your password";
        },
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChanged(password: value)),
      );
    });
  }

  //Sends form information to AWS for authentication
  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                //Validation check
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: const Text("Login"),
            );
    });
  }

  //Encapsulated form for BloC architecture purposes
  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBarOnFail(context, formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _usernameField(),
              _passwordField(),
              const SizedBox(
                height: 20,
              ),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  /* WIDGETS end*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SvgPicture.asset('assets/logo.svg'),
              const SizedBox(height: 16.0),
              Text('multiverse',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spartan(
                    textStyle: Theme.of(context).textTheme.headline5,
                  )),
            ],
          ),
          const SizedBox(height: 48.0),
          BlocProvider(
            child: _loginForm(),
            create: (context) => LoginBloc(
              authRepo: context.read<AuthRepository>(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
            },
            child: const Text('Skip to dashboard'),
          ),
        ],
      ),
    );
  }
}

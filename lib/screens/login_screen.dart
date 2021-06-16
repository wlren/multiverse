//Packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiverse/auth/auth_cubit.dart';
import 'package:provider/provider.dart';

//Local Files
import '../auth/form_submission_status.dart';
import '../auth/login/login_bloc.dart';
import '../auth/login/login_event.dart';
import '../auth/login/login_state.dart';
import '../repository/auth_repository.dart';

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

  //NUS NetID email widget
  Widget __buildEmailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          filled: true,
          labelText: 'NUSNET Email',
          suffixText: '@u.nus.edu',
        ),
        //Validation check
        validator: (value) {
          return state.isEmailValid ? null : 'exxxxxxx (7 digits)';
        },
        onChanged: (value) => context.read<LoginBloc>().add(
          LoginUsernameChanged(email: value + '@u.nus.edu'),
        ),
      );
    });
  }

  //Password field widget
  Widget _buildPasswordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Password',
        ),
        //Validation check
        validator: (_) {
          return state.isPasswordValid ? null : 'Password cannot be empty';
        },
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChanged(password: value)),
      );
    });
  }

  //Sends form information to AWS for authentication
  Widget _buildLoginButton() {
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
              child: const Text('Login'),
            );
    });
  }

  //Encapsulated form for BloC architecture purposes
  Widget __buildLoginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBarOnFail(
              context, formStatus.loginException.message ?? 'Login failed');
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              __buildEmailField(),
              const SizedBox(height: 16.0),
              _buildPasswordField(),
              const SizedBox(height: 16.0),
              _buildLoginButton(),
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SvgPicture.asset('assets/logo.svg'),
                    const SizedBox(height: 16.0),
                    Text(
                      'multiverse',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spartan(
                        textStyle: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                BlocProvider(
                  child: __buildLoginForm(),
                  create: (context) => LoginBloc(
                      authRepo: context.read<AuthRepository>(),
                      authCubit: context.read<AuthCubit>()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

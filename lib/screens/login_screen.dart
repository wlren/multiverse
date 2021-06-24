//Packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//Local Files
import '../model/auth/auth_cubit.dart';
import '../model/auth/login/login_form_bloc.dart';
import '../model/auth/login/login_form_event.dart';
import '../model/auth/login/login_form_state.dart';
import '../model/login_model.dart';
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
    return Builder(builder: (context) {
      final loginModel = context.read<LoginModel>();
      return TextFormField(
        decoration: const InputDecoration(
          filled: true,
          labelText: 'NUSNET Email',
          suffixText: '@u.nus.edu',
        ),
        //Validation check
        validator: (value) {
          return loginModel.isEmailValid ? null : 'exxxxxxx (7 digits)';
        },
        onChanged: (value) {
          loginModel.email = value + '@u.nus.edu';
        },
      );
    });
  }

  //Password field widget
  Widget _buildPasswordField() {
    return Builder(builder: (context) {
      final loginModel = context.read<LoginModel>();
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Password',
        ),
        //Validation check
        validator: (_) {
          return loginModel.isPasswordValid ? null : 'Password cannot be empty';
        },
        onChanged: (value) {
          loginModel.password = value;
        },
      );
    });
  }

  //Sends form information to AWS for authentication
  Widget _buildLoginButton() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(builder: (context, state) {
      final loginModel = context.read<LoginModel>();
      return state is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                //Validation check
                if (_formKey.currentState!.validate()) {
                  context.read<LoginFormBloc>().add(LoginFormSubmitted(
                    email: loginModel.email,
                    password: loginModel.password,
                  ));
                }
              },
              child: const Text('Login'),
            );
    });
  }

  //Encapsulated form for BloC architecture purposes
  Widget __buildLoginForm() {
    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        final formStatus = state;
        if (formStatus is SubmissionFailed) {
          _showSnackBarOnFail(
              context, formStatus.loginException.message ?? 'Login failed');
        }
      },
      child: ChangeNotifierProvider(
        create: (context) => LoginModel(),
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
                _buildRememberPasswordCheckBox(),
                _buildLoginButton(),
              ],
            ),
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
                  create: (context) => LoginFormBloc(
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

  Widget _buildRememberPasswordCheckBox() {
    return Builder(builder: (context) {
      final loginModel = context.watch<LoginModel>();
      return CheckboxListTile(
        title: const Text('Remember password'),
        value: loginModel.shouldRememberPassword,
        onChanged: (value) {
          loginModel.shouldRememberPassword = value ?? false;
        },
      );
    });
  }
}

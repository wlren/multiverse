//Packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//Local Files
import '../model/auth/login/login_form_bloc.dart';
import '../model/auth/login/login_form_event.dart';
import '../model/auth/login/login_form_state.dart';
import '../model/auth/session_cubit.dart';
import '../model/login_model.dart';

/// The initial screen which user would see upon launching app
/// prompts user to log in and will authenticate using Firebase
/// Authentication services
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  create: (context) =>
                      LoginFormBloc(sessionCubit: context.read<SessionCubit>()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBarOnFail(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildEmailField() {
    return Builder(builder: (context) {
      return TextFormField(
        decoration: const InputDecoration(
          filled: true,
          labelText: 'NUSNET Email',
          suffixText: '@u.nus.edu',
        ),
        //Validation check
        validator: (value) {
          return context.read<LoginModel>().isEmailValid
              ? null
              : 'exxxxxxx (7 digits)';
        },
        onChanged: (value) {
          context.read<LoginModel>().email = value + '@u.nus.edu';
        },
      );
    });
  }

  Widget _buildPasswordField() {
    return Builder(builder: (context) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Password',
        ),
        //Validation check
        validator: (_) {
          return context.read<LoginModel>().isPasswordValid
              ? null
              : 'Password cannot be empty';
        },
        onChanged: (value) {
          context.read<LoginModel>().password = value;
        },
      );
    });
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
        builder: (context, state) {
      return state is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                final loginModel = context.read<LoginModel>();
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

  Widget __buildLoginForm() {
    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        final formStatus = state;
        if (formStatus is SubmissionFailed) {
          _showSnackBarOnFail(context, formStatus.loginException.message);
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
                _buildEmailField(),
                const SizedBox(height: 16.0),
                _buildPasswordField(),
                const SizedBox(height: 16.0),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

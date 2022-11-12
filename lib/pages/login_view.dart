import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/pages/home_view.dart';
import 'package:instagram/pages/sign_up.dart';
import 'package:instagram/service/auth.dart';
import '../widgets/text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
  static const routeName = '/LoginPage';
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {});
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).popAndPushNamed(HomeView.routeName);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      //  showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(top: 180, right: 94, left: 94),
              child: SvgPicture.asset('assets/inst_logo.svg'),
            ),
            SizedBox(
              height: 41,
            ),
            TextFieldWidget(
              hintText: 'email',
              textEditingController: _emailController,
            ),
            SizedBox(
              height: 12,
            ),
            TextFieldWidget(
              isPass: true,
              hintText: 'password',
              textEditingController: _passwordController,
            ),
            SizedBox(
              height: 63,
            ),
            Container(
                width: 343,
                height: 55,
                child: CupertinoButton.filled(
                    child: _isLoading == false
                        ? const Text(
                            'Log in',
                          )
                        : const CircularProgressIndicator(
                            color: (Colors.white),
                          ),
                    onPressed: loginUser)),
            SizedBox(
              height: 63,
            ),
            Row(children: [
              SizedBox(
                width: 70,
              ),
              Text('Don’t have an account?'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(SignUp.routeName);
                  },
                  child: Text('Sign up')),
            ])
          ]),
        )),
      ),
    );
  }
}

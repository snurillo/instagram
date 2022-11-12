import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart';
import 'package:instagram/pages/home_view.dart';
import 'package:instagram/pages/login_view.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/service/auth.dart';

import '../widgets/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
  static const routeName = '/sighUpPage';
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).popAndPushNamed(HomeView.routeName);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      //showSnackBar(context, res);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
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
              padding: const EdgeInsets.only(top: 10, right: 94, left: 94),
              child: SvgPicture.asset('assets/inst_logo.svg'),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: selectImage,
              child: Badge(
                  borderSide: BorderSide(width: 3, color: Colors.white),
                  padding: EdgeInsets.all(5),
                  badgeColor: Colors.blue,
                  badgeContent: Icon(Icons.add),
                  position: BadgePosition(top: 70, end: -10),
                  child: Stack(children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.red,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: Colors.red,
                          ),
                  ])),
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
              hintText: 'username',
              textEditingController: _usernameController,
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
              height: 12,
            ),
            TextFieldWidget(
              hintText: 'bio',
              textEditingController: _bioController,
            ),
            SizedBox(
              height: 63,
            ),
            Container(
                width: 343,
                height: 55,
                child: CupertinoButton.filled(
                    child: _isLoading == true
                        ? CircularProgressIndicator(
                            color: (Colors.white),
                          )
                        : Text('Sign up'),
                    onPressed: signUpUser)),
            SizedBox(
              height: 63,
            ),
            Row(children: [
              SizedBox(
                width: 70,
              ),
              Text('Already have an account?'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(Login.routeName);
                  },
                  child: Text('Log in')),
            ])
          ]),
        )),
      ),
    );
  }
}

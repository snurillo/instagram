// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram/pages/login_view.dart';
import 'package:instagram/pages/sign_up.dart';
import 'package:instagram/providers/provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => Login(),
          Login.routeName: (context) => Login(),
          HomeView.routeName: (context) => HomeView(
                uid: FirebaseAuth.instance.currentUser!.uid,
              ),
          SignUp.routeName: (context) => SignUp(),
        },
        home: /* AnimatedSplashScreen(
            backgroundColor: Color.fromARGB(255, 0, 4, 31),
            splashTransition: SplashTransition.rotationTransition,
            duration: 500,
            splash: Container(
              width: 200,
              height: 600,
              child: Image.asset(
                'assets/image/splash.png',
              ),
            ), 
            nextScreen:*/
            StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return HomeView(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Login();
          },
        ),
      ),
    );
  }
}

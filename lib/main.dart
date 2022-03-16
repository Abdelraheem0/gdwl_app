//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gdwl/view/screens/splash_screen.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';
import 'shared/bloc_observer.dart';
import 'view/screens/createlist_screen.dart';
import 'view/screens/layout.dart';

void main() async {
  BlocOverrides.runZoned(
        () {
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => AppCubit()..initDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context , state){},
        builder: (context , state){
          return  MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'IBM',
              ),
              initialRoute: '/splashScreen',
              routes: {
                '/': (context) => LayoutScreen(),
                '/createList': (context) => CreateNewList(),
//                '/taskDetails': (context) => TaskDetailsScreen(),
                '/splashScreen': (context) => SplashScreen(),
              }
          );
        } ,
      ),
    );

  }
}
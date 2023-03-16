import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/firebase_auth_provider.dart';
import 'package:flutter_course/views/home_page.dart';
import 'package:flutter_course/views/notes/create_update_note_view.dart';
import 'package:flutter_course/views/notes/notes_view.dart';
import 'package:flutter_course/views/register_view.dart';
import 'package:flutter_course/views/veiry_email_view.dart';
import 'package:flutter_course/views/login_view.dart';
import 'package:flutter_course/views/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: CustomColor.kSecondaryColor,
        shadowColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(
        color: Color(0xFF6078ea),
      )),
      fontFamily: "Poppins-Medium",
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ).copyWith(
        secondary: const Color(0xFF5d74e3),
      ),
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      welcomeRoute: (context) => const WelcomeScreen(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
    },
  ));
}


// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _textEditingController;

//   @override
//   void initState() {
//     _textEditingController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => CounterBloc(),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Testing bloc'),
//           ),
//           body: BlocConsumer<CounterBloc, CounterState>(
//             listener: (context, state) {
//               _textEditingController.clear();
//             },
//             builder: (context, state) {
//               final invalidValue = (state is CounterStateInvalidNumber)
                  // ? state.invalidValue
//                   : '';
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Current value => ${state.value}'),
//                   Visibility(
//                       visible: state is CounterStateInvalidNumber,
//                       child: Text('Invalid input: $invalidValue')),
//                   TextField(
//                     controller: _textEditingController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter a number here',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           context
//                               .read<CounterBloc>()
//                               .add(DecrementValue(_textEditingController.text));
//                         },
//                         child: const Text('-'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           context
//                               .read<CounterBloc>()
//                               .add(IncrementEvent(_textEditingController.text));
//                         },
//                         child: const Text('+'),
//                       )
//                     ],
//                   )
//                 ],
//               );
//             },
//           ),
//         ));
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;

//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber(
//       {required this.invalidValue, required int previousValue})
//       : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementValue extends CounterEvent {
//   const DecrementValue(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on<DecrementValue>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }

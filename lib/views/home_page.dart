// import 'package:flutter/material.dart';
// import 'package:flutter_course/services/auth/auth_service.dart';
// import 'package:flutter_course/views/notes/notes_view.dart';
// import 'package:flutter_course/views/veiry_email_view.dart';
// import 'package:flutter_course/views/welcome_view.dart';
// import 'package:flutter_course/widgets/loading_indicator.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthService authService = AuthService.firebase();
//     ScreenUtil.init(context, designSize: const Size(1080, 2340));

//     return FutureBuilder(
//         future: authService.initialiize(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               final user = authService.currentUser;
//               if (user != null) {
//                 if (user.isEmailVerified) {
//                   return const SafeArea(child: NotesView());
//                 } else {
//                   return const VerifyEmailView();
//                 }
//               } else {
//                 return const WelcomeScreen();
//               }
//             default:
//               return customLoadingIndicator();
//           }
//         });
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Testing bloc'),
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
            listener: (context, state) {
              _textEditingController.clear();
            },
            builder: (context, state) {
              final invalidValue = (state is CounterStateInvalidNumber)
                  ? state.invalidValue
                  : '';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Current value => ${state.value}'),
                  Visibility(
                      visible: state is CounterStateInvalidNumber,
                      child: Text('Invalid input: $invalidValue')),
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a number here',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementValue(_textEditingController.text));
                        },
                        child: const Text('-'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_textEditingController.text));
                        },
                        child: const Text('+'),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ));
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber(
      {required this.invalidValue, required int previousValue})
      : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementValue extends CounterEvent {
  const DecrementValue(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementValue>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}

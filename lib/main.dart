import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // // logger.i("Initializing widgets...");
  // WidgetsFlutterBinding.ensureInitialized();
  // await initializeLogger();
  // logger.i("Initializing firebase...");
  // await AuthService.firebase().initialize();
  // /* TODO Setup theme change and light mode change */
  // await loadSavedTheme(); // Load persisted theme FIRST
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
          appBar: AppBar(title: Text("Testing bloc"), centerTitle: true),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<CounterBloc, CounterState>(
              listener: (context, state) {
                _controller.clear();
              },
              builder: (context, state) {
                final invalidValue = (state is CounterStateInvalidNumber)
                    ? state.invalidValue
                    : '';

                return Column(
                  children: [
                    Text("Current value: ${state.value}"),
                    Visibility(
                      visible: state is CounterStateInvalidNumber,
                      child: Text("Invalid input: $invalidValue"),
                    ),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Enter a number",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<CounterBloc>().add(
                              IncreamentEvent(_controller.text),
                            );
                          },
                          child: Text("+"),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CounterBloc>().add(
                              DecrementEvent(_controller.text),
                            );
                          },
                          child: Text("-"),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(super.value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncreamentEvent extends CounterEvent {
  const IncreamentEvent(super.value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncreamentEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}

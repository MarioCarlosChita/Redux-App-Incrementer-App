import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppState {
  int value;
  AppState({required this.value});
  int getValue() => value;
  void setValue(int value) => this.value = value;

  factory AppState.initial() => AppState(value: 0);
  AppState copyState(int? value) {
    return AppState(value: value ?? this.value);
  }
}

enum Action { Increment, Decrement }

AppState counterReducer(AppState state, event) {
  if (event == Action.Decrement) {
    state = state.copyState(state.value - 1);
    return state;
  }
  state = state.copyState(state.value + 1);

  return state;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Store<AppState> store =
      Store<AppState>(counterReducer, initialState: AppState.initial());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (_, AppState state) {
                    return Text(
                      state.value.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    );
                  })
            ],
          ),
        ),
        floatingActionButton: StoreConnector<AppState, VoidCallback>(
          converter: (store) {
            return _onIncrement;
          },
          builder: (context, callback) {
            return FloatingActionButton(
              // Attach the `callback` to the `onPressed` attribute
              onPressed: callback,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build metho;
  }

  void _onIncrement() {
    store.dispatch(Action.Increment);
  }
}

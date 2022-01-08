import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main(List<String> args) {
  runApp(const ProviderScope(child: MyApp()));
}

// Provider scope is a provider that stores the state of all our providers
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePageClock(),
      //const HomePageV4(),
      //const HomePageV3(), //const HomePageStateful(), //const HomePage(),
    );
  }
}

/// The Providers are Global but their state is not.
// When the state is immutable === ValueNotifierProvider<int>
final valueProvider = Provider<int>((ref) => 10);

/// Using a ConsumerWidget & Consumer ===> StatelessWidget
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        final value = ref.watch(valueProvider);

        /// Now it like we did Provider.of<int>(context, listen:true);
        /// The widget is reactive
        return Center(
          child: Text('Likes 👍: $value'),
        );
      }),
    );
  }
}

class HomePageV2 extends ConsumerWidget {
  const HomePageV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(valueProvider);

    return Scaffold(
      body: Center(
        child: Text('Likes 🥑: $value'),
      ),
    );
  }
}

/// Using a ConsumerStateWidget & ConsumerState ===> StatefulWidget
class HomePageStateful extends ConsumerStatefulWidget {
  const HomePageStateful({Key? key}) : super(key: key);

  @override
  _HomePageStatefulState createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends ConsumerState<HomePageStateful> {
  /// Now we have the WidgetRef ref as a property just like the BuildContext context
  var _count;
  @override
  void initState() {
    super.initState();

    /// use ref.read() in the widget life-cycle methods
    _count = ref.read(valueProvider);
  }

  @override
  Widget build(BuildContext context) {
    /// use ref.watch() in the widget build method

    final value = ref.watch(valueProvider);
    return Scaffold(
      body: Center(
        child: Text('Likes 🔥: $_count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// StateProvider
final counterProvider = StateProvider<int>((ref) => 0);

/// with this state provider we can change the value not only read it
class HomePageV3 extends ConsumerWidget {
  const HomePageV3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _count = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Text('Likes 🚀 🚀: $_count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.state).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Listening to Provider State Changes ---> ref.listen inside the build and then show a dialog or snackbar
class HomePageV4 extends ConsumerWidget {
  const HomePageV4({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _count = ref.watch(counterProvider);
    ref.listen<int>(
      counterProvider,

      /// note: this callback executes when the provider value changes,
      /// not when the build method is called
      /// Hence we can use it to run any asynchronous code (such as a network request), just like we do with regular button callbacks.
      (prev, cur) {
        //print('prev: $prev | cur: $cur');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('prev: $prev | cur: $cur'),
          ),
        );
      },
    );
    return Scaffold(
      body: Center(
        child: Text('Likes 🚀 🚀: $_count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.state).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Clock extends StateNotifier<DateTime> {
  Clock() : super(DateTime.now()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = DateTime.now();
    });
  }
  late final Timer _timer;
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final clockStateProvider = StateNotifierProvider<Clock, DateTime>(
  (ref) => Clock(),
);

class HomePageClock extends ConsumerWidget {
  const HomePageClock({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(clockStateProvider);
    final time = DateFormat.Hms().format(clock);
    return Scaffold(
      body: Center(
        child: Text('🚀 $time 🚀'),
      ),
    );
  }
}

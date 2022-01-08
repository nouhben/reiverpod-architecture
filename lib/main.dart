import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_architecture/models/colck.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const ClockHomePage(), //const ThirdHomeStatefulPage(),
      //const OtherHomePage(), //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final valueProvider = Provider<int>((ref) => 10);
final counterStateProvider = StateProvider<int>((ref) => 0);

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    print('re-build');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer(
              builder: (context, ref, child) {
                print('re-build | Text');

                final value = ref.watch(counterStateProvider);
                return Text(
                  '$value',
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          print('re-build | FAB');

          return FloatingActionButton(
            onPressed: () {
              ref.read(counterStateProvider.state).state++;
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class OtherHomePage extends ConsumerWidget {
  const OtherHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    print('Re-build | ui');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text('$counter'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterStateProvider.state).state++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ThirdHomeStatefulPage extends ConsumerStatefulWidget {
  const ThirdHomeStatefulPage({Key? key}) : super(key: key);

  @override
  _ThirdHomeStatefulPageState createState() => _ThirdHomeStatefulPageState();
}

class _ThirdHomeStatefulPageState extends ConsumerState<ThirdHomeStatefulPage> {
  @override
  void initState() {
    super.initState();
    final value = ref.read(valueProvider);
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(valueProvider);

    print('re-build');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text('$value'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Listen to changes
class ListenHomePage extends ConsumerWidget {
  const ListenHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    ref.listen<int>(
      counterStateProvider,
      (prev, cur) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Value is: $cur'),
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text('$counter'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterStateProvider.state).state++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final clockProvider = StateNotifierProvider<Clock, DateTime>((ref) => Clock());

class ClockHomePage extends ConsumerWidget {
  const ClockHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(clockProvider);
    final formattedTime = DateFormat.Hms().format(currentTime);
    return Scaffold(
      body: Center(
        child: Text(
          formattedTime,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

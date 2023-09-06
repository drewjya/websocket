import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:websocket/src/core/common/provider/data_provider.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              return ref.watch(dataCProvider).when(data: (data) {
                return Text("${data.toMap()}");
              }, error: (error, stackTrace) {
                return Text("${error}");
              }, loading: () {
                return const CircularProgressIndicator();
              });
            },
          ),
        ),
        floatingActionButton: Consumer(builder: (context, ref, child) {
          return FloatingActionButton(onPressed: () {
            ref.read(dataCProvider.notifier).payload(message: "Bapakkau");
          });
        }),
      ),
    );
  }
}

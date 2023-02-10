import 'package:flutter/material.dart';
import 'package:myapp/feauters/quotes/presentation/pages/quote_widget.dart';
import 'package:myapp/injection_conatiner.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuoteWidget(),
    );
  }
}

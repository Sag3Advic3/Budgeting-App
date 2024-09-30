import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

String outputText = "";
  final myController = TextEditingController();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Budgeting App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = IncomePage();
    switch (selectedIndex) {
      case 0:
        page = IncomePage();
      case 1:
        page = Placeholder();
      case 2:
        page = Placeholder();
      case 3:
        calculateTotal();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.account_balance),
                    label: Text('Income'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.payment),
                    label: Text('Payments'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.savings),
                    label: Text('Savings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calculate),
                    label: Text('Calculate'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }

  void calculateTotal() {
    outputText = myController.text;
  }
}

class IncomePage extends StatefulWidget {
  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("INCOME"),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Net Income 1:"),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width) / 4,
                child: TextFormField(
                  controller: myController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: validateInput,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(outputText),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Test Output 2"),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextEditingController get getValue => myController;

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a value';
    }
    return null;
  }
}

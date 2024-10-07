import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

String outputText = "";
const List<String> frequencyList = <String>['Daily', 'Weekly', 'Bi-Weekly', 'Monthly', 'Quarterly', 'Bi-Annually', 'Annually'];
final income1Controller = TextEditingController();
final income2Controller = TextEditingController();

void main() {
  runApp(const MyApp());
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
  const MyHomePage({super.key});

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
        page = const Placeholder();
      case 2:
        page = const Placeholder();
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
                destinations: const [
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
    int income1 = int.parse(income1Controller.text);
    int income2 = int.parse(income2Controller.text);

    outputText = (income1 + income2).toString();
  }
}

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("INCOME"),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Net Income 1:"),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width) / 4,
                child: TextFormField(
                  controller: income1Controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: validateInput,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: (MediaQuery.of(context).size.width) / 4,
                    child: frequencyDD()),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Net Income 2:"),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width) / 4,
                child: TextFormField(
                  controller: income2Controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: validateInput,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.white),
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(outputText),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Test Output 2"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a value';
    }
    return null;
  }
}

class frequencyDD extends StatefulWidget {
  const frequencyDD({super.key});

  @override
  State<frequencyDD> createState() => _frequencyDDState();
}

class _frequencyDDState extends State<frequencyDD> {
  String dropdownValue = frequencyList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: frequencyList.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: frequencyList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils/currency.dart';
import 'package:flutter_application_2/widgets/theme_change.dart';
import 'package:flutter_application_2/widgets/main_bot_navbar.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Currency> data;

  @override
  void initState() {
    super.initState();
    data = fetchData(
      "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_tKrVyW8ijlDcOONTG4MOjjPEYDp14VnG04sI4cYu",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [ThemeChangeIcon()],
      ),
      bottomNavigationBar: MainNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          developer.log("button pressed", level: 200);
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Welcome to Budgee!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Track your expenses and manage your budget effectively.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Get started by adding your first transaction!",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Stay tuned for more features coming soon.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              FutureBuilder(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.eur.toString());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

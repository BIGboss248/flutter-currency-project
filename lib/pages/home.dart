import 'package:budgee/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:budgee/utils/currency.dart';
import 'package:budgee/widgets/main_drawer.dart';
import 'package:budgee/widgets/main_bot_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.pageIndex, super.key});

  final int pageIndex;

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
      ),
      endDrawer: MainDrawer(),
      bottomNavigationBar: MainNavBar(currentIndex: widget.pageIndex),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          logger.i("button pressed");
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

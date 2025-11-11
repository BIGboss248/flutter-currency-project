import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/widgetLibrary.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: MainNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print("button pressed");
        },
      ),
      body: Center(
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
          ],
        ),
      ),
    );
  }
}

/*
The idea is that we fetch data from a URI then we parse the JSON into a model to use it
for more info visit https://docs.flutter.dev/cookbook/networking/fetch-data

* We follow these steps:
*   1. Import http package
*   2. Make a network request to get the data from internet
*   3. Parse the JSON data to a model
*/

//* 1. Import http package

/*
! for macos and android deployment check bellow

for android add bellow to AndroidManifest.xml
  <!-- Required to fetch data from the internet. -->
  <uses-permission android:name="android.permission.INTERNET" />

if you are deploying to macOS, edit your macos/Runner/DebugProfile.entitlements and macos/Runner/Release.entitlements files to include the network  client entitlement.
  <key>com.apple.security.network.client</key>
  <true/>

*/

//* 2. Make a network request to get the data from internet

/*

# fetchData

  This function fetches data from a given URI and returns the HTTP response.

  Parameters:
  address (String): The URI to fetch data from.
  Returns:
  A Future that resolves to an http.Response containing the data from the URI.
  

*/
Future<http.Response> fetchData([
  String address =
      'https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_tKrVyW8ijlDcOONTG4MOjjPEYDp14VnG04sI4cYu',
]) {
  return http.get(Uri.parse(address));
}

//* 3. Parse the JSON data to a model

class Data {
  // Define the properties of the model that the API returns.
  final int EUR;
  final int GBP;

  // Constructor for the Data model. required properties can't be null.
  const Data({required this.EUR, required this.GBP});

  // Factory method to create a Data instance from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) {
    // switch expression to parse JSON and create a Data instance.
    return switch (json) {
      // Here each key variable type is defined and is matched to the value from JSON.
      {'EUR': int EUR, 'GBP': int GBP} => Data(EUR: EUR, GBP: GBP),
      // Throw an exception if JSON structure is missing a key or has an unexpected type.
      _ => throw const FormatException('Failed to load Data.'),
    };
  }
}

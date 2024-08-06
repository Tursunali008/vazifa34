import 'package:flutter/material.dart';
import 'package:search_points/search_points.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _listController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchAlgorithm = 'Linear';
  List<dynamic> _dataList = [];
  List<dynamic> _searchResults = [];
  int _searchTime = 0;

  void _search() {
    final String target = _searchController.text;
    final List<dynamic> results = [];
    final searchPoints = SearchPoints(); // Create an instance of SearchPoints

    final stopwatch = Stopwatch()..start(); // Start the stopwatch

    switch (_searchAlgorithm) {
      case 'Binary':
        results.addAll(searchPoints.binarySearch(_dataList, target));
        break;
      case 'Jump':
        results.addAll(searchPoints.jumpSearch(_dataList, target));
        break;
      default:
        results.addAll(searchPoints.linearSearch(_dataList, target));
    }

    stopwatch.stop(); // Stop the stopwatch

    setState(() {
      _searchResults = results;
      _searchTime = stopwatch.elapsedMilliseconds; // Record the elapsed time in milliseconds
    });
  }

  void _updateList() {
    final String listText = _listController.text;
    setState(() {
      _dataList = listText.split(' ').map((e) => e.trim()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SearchBar"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _listController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter list (space separated)', // Fix the typo from 'spase' to 'space'
              ),
              onChanged: (text) => _updateList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter search term',
              ),
              keyboardType: TextInputType.text, // Allow text input
            ),
          ),
          DropdownButton<String>(
            value: _searchAlgorithm,
            onChanged: (String? newValue) {
              setState(() {
                _searchAlgorithm = newValue!;
              });
            },
            items: <String>['Linear', 'Binary', 'Jump']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: _search,
            child: const Text('Search'),
          ),
          Text('Search Time: $_searchTime ms'), // Display search time
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Result Index: ${_searchResults[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

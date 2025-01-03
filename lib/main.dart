import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Student Grade Project',
      home: Home(),
    );
  }
}

//test

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> students = [];
  List<Map<String, String>> filteredStudents = [];

  Future<void> myApi() async {
    final url = 'http://projecttestwaelawada.atwebpages.com/students.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] != null) {
          List<Map<String, String>> fetchedStudents = [];
          for (var student in data['data']) {
            fetchedStudents.add({
              'id': student['id'] ?? '',
              'full_name': student['full_name'] ?? '',
              'class': student['class'] ?? '',
              'grade': student['grade'] ?? '',
            });
          }
          setState(() {
            students = fetchedStudents;
            filteredStudents = students;
          });
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void searchStudents(String query) {
    setState(() {
      filteredStudents = students
          .where((student) =>
              student['full_name']!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              student['id']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  getStudents() {
    myApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Student Grade Project',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: getStudents,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Get Students From Database',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search by ID or Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                enabled: students != null && students.isNotEmpty,
                onChanged: searchStudents,
              ),
              const SizedBox(height: 20),
              DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('full_name')),
                  DataColumn(label: Text('Class')),
                  DataColumn(label: Text('Grade')),
                ],
                rows: filteredStudents
                    .map(
                      (student) => DataRow(
                        cells: [
                          DataCell(Text(student['id']!)),
                          DataCell(Text(student['full_name']!)),
                          DataCell(Text(student['class']!)),
                          DataCell(Text(student['grade']!)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

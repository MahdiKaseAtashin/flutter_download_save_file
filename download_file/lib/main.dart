import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  downloadFile() async {
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('home'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton.icon(
            onPressed: downloadFile,
            icon: const Icon(Icons.download),
            label: const Text('Download File')),
      ),
    );
  }
}

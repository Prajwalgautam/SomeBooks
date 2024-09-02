import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home()

  ));
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('some msg'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        // child: Icon(
        //   Icons.airport_shuttle
        // )
        child: ElevatedButton.icon(
            onPressed: (){},
            icon: Icon(Icons.mail),
            label: Text("mail me"),
            style: ElevatedButton.styleFrom(
              backgroundColor : Colors.amber,
            )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Text('click'),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}



import 'package:flutter/material.dart';

class Todolist extends StatelessWidget {
  static const routeName = '/todolist';
  const Todolist({super.key});

  @override
  Widget build(BuildContext context) {
    var _testStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Lato",
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO LIST'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExpansionTile(
            title: const Text('IT Activities'),
            childrenPadding:const EdgeInsets.all(10),
            leading:const Icon(Icons.local_activity_rounded),
            children: [
              ExpansionTile(
                title:const Text("Screen UI Development"),
                leading: Icon(Icons.task_alt),
                children: [
                  Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        TableRow(
                          children: [
                            Text(
                              "SubTask",
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Assigned Hours',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Target Date',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              "SubTask",
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Assigned Hours',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Target Date',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              "SubTask",
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Assigned Hours',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Target Date',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ])
                ],
              ),
              ExpansionTile(
                title: const Text("API Creation"),
                leading: Icon(Icons.task_alt),
                children: [
                  Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        TableRow(
                          children: [
                            Text(
                              "SubTask",
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Assigned Hours',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Target Date',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              "SubTask",
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Assigned Hours',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Target Date',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              "SubTask",
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Assigned Hours',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Target Date',
                              style: _testStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ])
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

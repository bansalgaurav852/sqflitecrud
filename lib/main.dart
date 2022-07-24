import 'package:flutter/material.dart';
import 'package:localdatabase/database.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    queryRow = await DatabaseHelper.instance.queryAll();
    setState(() {});
    print(queryRow);
  }

  List<Map<String, dynamic>>? queryRow;

  String nameOne = "Levels Kant";
  TextEditingController _controller = TextEditingController();
  TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Exaple'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter  to  do"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                child: Text("Add"),
                color: Colors.green,
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    await DatabaseHelper.instance.insert({
                      DatabaseHelper.columnName: _controller.text
                    }).then((value) async {
                      await getdata();
                    });
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
          if (queryRow != null)
            Expanded(
                child: ListView.builder(
                    itemCount: queryRow!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text((index + 1).toString()
                            // queryRow![index]["_id"].toString(),
                            ),
                        title: InkWell(
                          onTap: () {
                            _editingController = TextEditingController(
                                text: queryRow![index]["name"]);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Update"),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _editingController,
                                          decoration: const InputDecoration(
                                              hintText: "update to do"),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "cancel",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (_editingController
                                                  .text.isNotEmpty) {
                                                await DatabaseHelper.instance
                                                    .update(
                                                  {
                                                    "_id": queryRow![index]
                                                        ['_id'],
                                                    'name':
                                                        _editingController.text
                                                  },
                                                ).then((value) async {
                                                  await getdata();
                                                  Navigator.pop(context);
                                                });

                                                _editingController.clear();
                                              }
                                            },
                                            child: Text("update"),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            queryRow![index]["name"].toString(),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelper.instance
                                .delete(queryRow![index]["_id"])
                                .then((value) async {
                              queryRow =
                                  await DatabaseHelper.instance.queryAll();
                              setState(() {});
                            });
                          },
                        ),
                      );
                    }))
        ],
      ),
    );
  }
}

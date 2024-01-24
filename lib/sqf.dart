import 'package:flutter/material.dart';
import './sqlhelper.dart';

class SqlScreen extends StatefulWidget {
  @override
  _SqlScreenState createState() => _SqlScreenState();
}

class _SqlScreenState extends State<SqlScreen> {
  List<Map<String, dynamic>> array = [];

  bool isloading = true;
  void refreshitem() async {
    final data = await SQLhelper.getItems();
    setState(() {
      array = data;
      isloading = false;
    });
  }

  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> additemfromui() async {
    await SQLhelper.insertItem(
        nameController.text, authorController.text, descriptionController.text);
    refreshitem();
  }

  Future<void> deleteitemfromui(int id) async {
    await SQLhelper.deleteItem(id);
    refreshitem();
  }

  Future<void> updateitemfromui(
      int id, String title, String author, String description) async {
    await SQLhelper.updateItem(id, title, author, description);
    refreshitem();
  }

  @override
  void initState() {
    super.initState();
    refreshitem();
  }

  void showOptionsDialog(BuildContext context, int itemId, String title,
      String disc, String price) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  showEditDialog(context, itemId, title, disc, price);
                },
                child: Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  showDeleteDialog(context, itemId);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditDialog(BuildContext context, int itemId, String title,
      String disc, String price) {
    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController discController =
        TextEditingController(text: disc);
    final TextEditingController priceController =
        TextEditingController(text: price);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: discController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Description'),
                // keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Extract the updated values from the TextFields
                final updatedTitle = titleController.text;
                final updatedauthor = discController.text;
                final updateddescription = priceController.text;
                updateitemfromui(
                    itemId, updatedTitle, updatedauthor, updateddescription);

                Navigator.of(context).pop();

                // Call the Edit function with the updated values
                // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, int itemId) {
    print(itemId);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Call the Delete function
                deleteitemfromui(itemId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: ListView.builder(
        itemCount: array.length,
        itemBuilder: (context, index) {
          final item = array[index];
          return ListTile(
            title: Text(item['title']),
            subtitle: Text(item['description']),
            trailing: Text(item['author']),
            onTap: () {
              print(item['id']);
              showOptionsDialog(context, item['id'], item['title'],
                  item['author'], item['description']);
              // Handle item click (e.g., Edit or Delete)
              // Example: Edit(item['id'], item['title'], item['disc'], item['price']);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog or a form to add a new item
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(labelText: 'Author'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    // Add input fields for 'disc' and 'price'
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      await additemfromui();
                      Navigator.of(context).pop();

                      nameController.text = "";
                      authorController.text = "";
                      descriptionController.text = "";
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

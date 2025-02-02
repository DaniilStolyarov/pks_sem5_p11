import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pks_sem5_p8/pages/edit_item.dart';
import '/components/card_preview.dart';
import '/main.dart';
import '/models/shop_item.dart';
import '/pages/add_item.dart';
import '/pages/item_view.dart';
import 'package:http/http.dart' as http;

class Catalog extends StatefulWidget {
  const Catalog({super.key});
  @override
  createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  List<ShopItem> shopItems = appData.shopItems;
  @override
  void initState() {
    super.initState();
  }

  void addItem(ShopItem item) {
    setState(() {
      shopItems.add(item);
    });
  }

  void removeItem(int index) {
    setState(() {
      int id = shopItems[index].ID;
      shopItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shopItems.isEmpty ? Center(child : Text("Похоже, что стрижек пока нет.")) : Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 21 / 20),
          padding: const EdgeInsets.symmetric(vertical: 0),
          itemCount: shopItems.length,
          itemBuilder: (BuildContext context, int index) {
            final itemKey = GlobalKey();
            return GestureDetector(
              key: itemKey,
              child: CardPreview(
                shopItem: shopItems[index],
              ),
              onTap: () {
                debugPrint('tapped ${shopItems[index].Name}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemView(shopItem: shopItems[index])));
              },
              onLongPress: () {
                // https://stackoverflow.com/questions/76172939/how-to-center-showmenu-in-flutter
                final screenSize = MediaQuery.of(context).size;
                final RenderBox box =
                    itemKey.currentContext!.findRenderObject() as RenderBox;
                final menuWidth = 150.0;
                final menuHeight = 100.0;
                final Offset position = box.localToGlobal(Offset.zero);
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        position.dx + 16,
                        position.dy + box.size.height / 2,
                        position.dx + menuWidth,
                        position.dy + menuHeight),
                    items: [
                      PopupMenuItem(
                        child: Text("Редактировать"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditItem(
                                      catalogState: this,
                                      itemID: shopItems[index].ID)));
                        },
                      ),
                      PopupMenuItem(
                        child: Text(
                          "Удалить",
                          style: TextStyle(color: Colors.red[800]),
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Удаление товара'),
                                  content: Text(
                                      'Вы действительно хотите удалить стрижку?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Отмена',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await http.delete(Uri(
                                            scheme: "http",
                                            host: appData.serverHost,
                                            port: appData.serverPort,
                                            path: "/service",
                                            queryParameters: {
                                              "id":
                                                  shopItems[index].ID.toString()
                                            }));
                                        setState(() {
                                          shopItems.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Удалить',
                                        style:
                                            TextStyle(color: Colors.red[800]),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      )
                    ]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddItem(
                        catalogState: this,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

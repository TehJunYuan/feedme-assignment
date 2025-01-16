import 'package:flutter/material.dart';
import 'dart:async';
import 'models/order.dart';
import 'models/bot.dart';
import 'widgets/order_list.dart';
import 'widgets/bot_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'McDonald\'s Order Controller',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'McDonald\'s Order Controller'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Order> orders = [];
  List<Bot> bots = [];
  int orderIdCounter = 1;

  void addNormalOrder() {
    setState(() {
      orders.add(Order(id: orderIdCounter++, type: 'Normal'));
    });
  }

  void addVIPOrder() {
    setState(() {
      final vipOrder = Order(id: orderIdCounter++, type: 'VIP');
      orders.insert(0, vipOrder);
    });
  }

  void addBot() {
    setState(() {
      bots.add(Bot(id: bots.length + 1));
    });
  }

  void removeBot() {
    if (bots.isNotEmpty) {
      setState(() {
        bots.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                OrderList(orders: orders),
                BotList(bots: bots),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: addNormalOrder,
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text('New Normal Order'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: addVIPOrder,
                      icon: Icon(Icons.star),
                      label: Text('New VIP Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: addBot,
                      icon: Icon(Icons.add),
                      label: Text('Add Bot'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: removeBot,
                      icon: Icon(Icons.remove),
                      label: Text('Remove Bot'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

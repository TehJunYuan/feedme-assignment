import 'package:flutter/material.dart';
import 'dart:async';
import 'models/order.dart';
import 'models/bot.dart';
import 'widgets/order_list.dart';
import 'widgets/bot_list.dart';
import 'widgets/completed_order_list.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  List<Order> completedOrders = [];
  List<Bot> bots = [];
  int orderIdCounter = 1;
  Map<int, Timer> botTimers = {};

  @override
  void dispose() {
    botTimers.values.forEach((timer) => timer.cancel());
    super.dispose();
  }

  void addNormalOrder() {
    setState(() {
      orders.add(Order(id: orderIdCounter++, type: 'Normal'));
      processOrders();
    });
  }

  void addVIPOrder() {
    setState(() {
      final vipOrder = Order(id: orderIdCounter++, type: 'VIP');
      orders.insert(0, vipOrder);
      processOrders();
    });
  }

  void addBot() {
    setState(() {
      bots.add(Bot(id: bots.length + 1));
      processOrders();
    });
  }

  void removeBot() {
    if (bots.isNotEmpty) {
      setState(() {
        final bot = bots.removeLast();

        if (bot.currentOrder != null) {
          botTimers[bot.id]?.cancel();
          botTimers.remove(bot.id);

          bot.currentOrder!.status = 'PENDING';
          orders.add(bot.currentOrder!);
        }
      });
    }
  }

  void processOrders() {
    orders.sort((a, b) {
      if (a.type == 'VIP' && b.type != 'VIP') return -1;
      if (a.type != 'VIP' && b.type == 'VIP') return 1;
      return 0;
    });

    for (final bot in bots) {
      if (bot.isIdle && orders.isNotEmpty) {
        final order = orders.removeAt(0);
        bot.isIdle = false;
        bot.currentOrder = order;

        botTimers[bot.id]?.cancel();

        botTimers[bot.id] = Timer(Duration(seconds: 10), () {
          setState(() {
            order.status = 'COMPLETE';
            completedOrders.add(order);
            bot.isIdle = true;
            bot.currentOrder = null;
            botTimers.remove(bot.id);
            processOrders();
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      OrderList(orders: orders),
                      BotList(bots: bots),
                    ],
                  ),
                ),
                Expanded(
                  child: CompletedOrderList(completedOrders: completedOrders),
                ),
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

import 'package:flutter/material.dart';
import 'dart:async';
import 'models/order.dart';
import 'models/bot.dart';
import 'widgets/order_list.dart';
import 'widgets/bot_list.dart';
import 'widgets/completed_order_list.dart';
import 'package:uuid/uuid.dart';

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
  final _uuid = const Uuid();
  List<Order> orders = [];
  List<Order> completedOrders = [];
  List<Bot> bots = [];
  int orderNumberCounter = 1;
  Map<int, Timer> botTimers = {};

  @override
  void dispose() {
    botTimers.values.forEach((timer) => timer.cancel());
    super.dispose();
  }

  void addVIPOrder() {
    setState(() {
      // Find the last VIP order index
      int lastVipIndex = orders.lastIndexWhere((order) => order.type == 'VIP');

      final vipOrder = Order(
        id: _uuid.v4(),
        orderNumber: orderNumberCounter++,
        type: 'VIP',
      );

      // Insert after the last VIP order, or at the beginning if no VIP orders
      orders.insert(lastVipIndex + 1, vipOrder);
      processOrders();
    });
  }

  void addNormalOrder() {
    setState(() {
      final normalOrder = Order(
        id: _uuid.v4(),
        orderNumber: orderNumberCounter++,
        type: 'Normal',
      );

      // Always add normal orders at the end
      orders.add(normalOrder);
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
          // Cancel the timer
          botTimers[bot.id]?.cancel();
          botTimers.remove(bot.id);

          // Just update the status back to PENDING
          bot.currentOrder!.status = 'PENDING';
          bot.currentOrder = null;
        }
      });
    }
  }

  void processOrders() {
    // Find an idle bot and the first pending order
    for (final bot in bots) {
      if (bot.isIdle) {
        final pendingOrderIndex =
            orders.indexWhere((order) => order.status == 'PENDING');

        if (pendingOrderIndex != -1) {
          final order = orders[pendingOrderIndex];

          order.status = 'PROCESSING';
          bot.isIdle = false;
          bot.currentOrder = order;

          botTimers[bot.id]?.cancel();

          botTimers[bot.id] = Timer(Duration(seconds: 10), () {
            setState(() {
              orders.remove(order);
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

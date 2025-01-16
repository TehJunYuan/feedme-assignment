import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderList extends StatelessWidget {
  final List<Order> orders;
  
  const OrderList({Key? key, required this.orders}) : super(key: key);

  List<Order> getSortedOrders() {
    return List<Order>.from(orders)
      ..sort((a, b) {
        if (a.type == 'VIP' && b.type != 'VIP') return -1;
        if (a.type != 'VIP' && b.type == 'VIP') return 1;
        return a.id.compareTo(b.id);
      });
  }

  @override
  Widget build(BuildContext context) {
    final sortedOrders = getSortedOrders();
    return Expanded(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pending_actions, color: Colors.orange, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'PENDING ORDERS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedOrders.length,
                  itemBuilder: (context, index) {
                    final order = sortedOrders[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: order.type == 'VIP' 
                          ? Colors.amber.shade50 
                          : Colors.grey.shade50,
                      child: ListTile(
                        leading: Icon(
                          order.type == 'VIP' 
                              ? Icons.star 
                              : Icons.fastfood,
                          color: order.type == 'VIP' 
                              ? Colors.amber 
                              : Colors.grey[700],
                        ),
                        title: Text(
                          'Order #${order.id} (${order.type})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Status: ${order.status}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
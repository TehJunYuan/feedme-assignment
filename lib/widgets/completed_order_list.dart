import 'package:flutter/material.dart';
import '../models/order.dart';

class CompletedOrderList extends StatelessWidget {
  final List<Order> completedOrders;
  
  const CompletedOrderList({Key? key, required this.completedOrders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    Icon(Icons.task_alt, color: Colors.green, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'COMPLETED ORDERS',
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
                  itemCount: completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = completedOrders[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: Colors.green.shade50,
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
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
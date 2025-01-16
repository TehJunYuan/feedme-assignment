import 'package:flutter/material.dart';
import '../models/bot.dart';

class BotList extends StatelessWidget {
  final List<Bot> bots;
  
  const BotList({Key? key, required this.bots}) : super(key: key);

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
                    Icon(Icons.smart_toy, color: Colors.blue, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'BOTS',
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
                  itemCount: bots.length,
                  itemBuilder: (context, index) {
                    final bot = bots[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: bot.isIdle 
                          ? Colors.green.shade50 
                          : Colors.red.shade50,
                      child: ListTile(
                        leading: Icon(
                          Icons.android,
                          color: bot.isIdle ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          'Bot #${bot.id}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          bot.isIdle
                              ? 'Status: IDLE'
                              : 'Processing Order #${bot.currentOrder!.id}',
                        ),
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
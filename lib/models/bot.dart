import 'order.dart';

class Bot {
  final int id;
  bool isIdle;
  Order? currentOrder;

  Bot({
    required this.id,
    this.isIdle = true,
    this.currentOrder,
  });
}

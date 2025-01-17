class Order {
  final String id;
  final int orderNumber;
  final String type;
  String status;

  Order({
    required this.id,
    required this.orderNumber,
    required this.type,
    this.status = 'PENDING',
  });
}

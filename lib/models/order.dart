class Order {
  final int id;
  final String type;
  String status;

  Order({
    required this.id, 
    required this.type, 
    this.status = 'PENDING'
  });
}

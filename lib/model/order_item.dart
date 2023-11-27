class OrderItem {
  final String name;
  final int quantity;

  const OrderItem({required this.name, required this.quantity});

  factory OrderItem.fromMap(Map<dynamic, dynamic> map) {
    return OrderItem(
      name: map['name'] as String,
      quantity: map['quantity'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}

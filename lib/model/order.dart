import 'package:simple_queue/model/order_item.dart';

enum OrderState { inKitchen, ready, completed }

class Order {
  final String id;
  final String customer;
  final List<OrderItem> items;
  final String description;
  final OrderState state;

  const Order({
    required this.id,
    required this.customer,
    required this.items,
    required this.description,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer': customer,
      'items': items.map((item) => item.toMap()).toList(),
      'description': description,
      'state': state.index,
    };
  }

  factory Order.fromMap(String id, Map<dynamic, dynamic> map) {
    return Order(
      id: id,
      customer: map['customer'] as String,
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      description: map['description'] as String,
      state: OrderState.values[map['state'] as int],
    );
  }
}

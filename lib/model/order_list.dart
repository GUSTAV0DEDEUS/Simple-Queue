import 'package:firebase_database/firebase_database.dart';
import 'package:simple_queue/model/order.dart';

class OrderList {
  final List<Order> orders;

  OrderList(this.orders);
}

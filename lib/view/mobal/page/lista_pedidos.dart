import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:simple_queue/model/order.dart';

class FetchOrders extends StatefulWidget {
  const FetchOrders({Key? key}) : super(key: key);

  @override
  State<FetchOrders> createState() => _FetchOrdersState();
}

class _FetchOrdersState extends State<FetchOrders> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Orders');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Orders');

  Widget listItem({required Order order}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 150,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer: ${order.customer}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Description: ${order.description}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'State: ${order.state.toString().split('.').last}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // Adicione a navegação para a tela de atualização aqui, se necessário
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => UpdateOrderScreen(order: order),
                  //   ),
                  // );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text('Edit'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  // Adicione a lógica para remover o pedido aqui
                  reference.child(order.id).remove();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                    const SizedBox(width: 4),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching Orders'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            if (snapshot.value != null &&
                snapshot.value is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> data =
                  snapshot.value as Map<dynamic, dynamic>;
              Order order = Order.fromMap(snapshot.key ?? '', data);

              return listItem(order: order);
            }

            return Container();
          },
        ),
      ),
    );
  }
}

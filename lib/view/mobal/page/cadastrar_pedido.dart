import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_queue/model/order.dart';
import 'package:simple_queue/model/order_item.dart';

class OrderEntryScreen extends StatefulWidget {
  const OrderEntryScreen({Key? key}) : super(key: key);

  @override
  _OrderEntryScreenState createState() => _OrderEntryScreenState();
}

class _OrderEntryScreenState extends State<OrderEntryScreen> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late DatabaseReference dbRef;
  List<OrderItem> orderItems = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Orders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: customerController,
              decoration: InputDecoration(labelText: 'Nome do Cliente'),
            ),
            SizedBox(height: 16.0),
            Text('Itens do Pedido'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemController,
                    decoration: InputDecoration(labelText: 'Item'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      orderItems.add(
                        OrderItem(
                          name: itemController.text,
                          quantity: int.tryParse(quantityController.text) ?? 0,
                        ),
                      );
                      itemController.clear();
                      quantityController.clear();
                    });
                  },
                  child: Text('Adicionar'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Itens Adicionados:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(orderItems[index].name),
                  subtitle: Text('Quantidade: ${orderItems[index].quantity}'),
                );
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição do Pedido'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitOrder();
              },
              child: Text('Enviar Pedido'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitOrder() async {
    String customerName = customerController.text;

    if (customerName.isNotEmpty && orderItems.isNotEmpty) {
      Order newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customer: customerName,
        items: orderItems,
        description:
            descriptionController.text, // Adiciona a descrição ao pedido
        state: OrderState.inKitchen,
      );
      Map<String, dynamic> orderMap = newOrder.toMap();

      dbRef.push().set(orderMap);
      setState(() {
        orderItems.clear();
        customerController.clear();
        descriptionController.clear(); // Limpa a descrição após enviar o pedido
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pedido Cadastrado'),
            content:
                Text('Seu pedido foi enviado com sucesso! ID: ${newOrder.id}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(
                'Preencha o nome do cliente, adicione itens ao pedido e inclua a descrição.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:simple_queue/view/mobal/page/cadastrar_pedido.dart';
import 'package:simple_queue/view/mobal/page/lista_pedidos.dart';

class TabbedScreen extends StatelessWidget {
  const TabbedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Simple Queue App'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Lista de Pedidos'),
              Tab(icon: Icon(Icons.add), text: 'Novo Pedido'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FetchOrders(),
            OrderEntryScreen(),
          ],
        ),
      ),
    );
  }
}

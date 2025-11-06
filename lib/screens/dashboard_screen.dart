import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Dashboard')),
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          }

          final items = snapshot.data ?? [];
          final totalItems = items.length;
          final totalValue = items.fold<double>(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );
          final outOfStock = items.where((item) => item.quantity == 0).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  color: Colors.blue[50],
                  child: ListTile(
                    title: const Text('Total Unique Items'),
                    trailing: Text('$totalItems'),
                  ),
                ),
                Card(
                  color: Colors.green[50],
                  child: ListTile(
                    title: const Text('Total Inventory Value'),
                    trailing: Text('\$${totalValue.toStringAsFixed(2)}'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Out of Stock Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...outOfStock.map(
                  (item) => ListTile(
                    title: Text(item.name),
                    subtitle: Text('Category: ${item.category}'),
                    trailing: const Text(
                      '0 left',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

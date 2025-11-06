import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  final CollectionReference itemsCollection = FirebaseFirestore.instance
      .collection('items');

  Future<void> addItem(Item item) async {
    await itemsCollection.add(item.toMap());
  }

  Stream<List<Item>> getItemsStream() {
    return itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> updateItem(Item item) async {
    await itemsCollection.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await itemsCollection.doc(itemId).delete();
  }
}

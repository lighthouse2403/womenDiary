import 'package:flutter/material.dart';

class ActionTypeTemp {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  ActionTypeTemp({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}

class ActionTypeList extends StatefulWidget {
  const ActionTypeList({Key? key}) : super(key: key);

  @override
  State<ActionTypeList> createState() => _ActionTypeListState();
}

class _ActionTypeListState extends State<ActionTypeList> {
  final List<ActionTypeTemp> _items = [
    ActionTypeTemp(id: '1', name: 'Đi bộ', emoji: '🚶‍♀️', color: Colors.green),
    ActionTypeTemp(id: '2', name: 'Chạy bộ', emoji: '🏃‍♂️', color: Colors.orange),
    ActionTypeTemp(id: '3', name: 'Ngủ', emoji: '😴', color: Colors.blue),
  ];

  void _removeItem(String id) {
    setState(() => _items.removeWhere((item) => item.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Action Type')),
      body: _items.isEmpty
          ? const Center(child: Text('Chưa có action type nào.'))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Dismissible(
            key: ValueKey(item.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => _removeItem(item.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.color,
                child: Text(item.emoji, style: const TextStyle(fontSize: 18)),
              ),
              title: Text(item.name),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------
// USAGE EXAMPLE
// runApp(MaterialApp(home: ActionTypeListScreen()));
// ---------------------------

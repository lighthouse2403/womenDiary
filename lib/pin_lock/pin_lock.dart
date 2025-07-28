import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinLockScreen extends StatefulWidget {
  final void Function() onUnlock;

  const PinLockScreen({super.key, required this.onUnlock});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController _controller = TextEditingController();
  String? savedPin;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final storage = FlutterSecureStorage();
    savedPin = await storage.read(key: 'pin_code');
  }

  void _validatePin() {
    if (_controller.text == savedPin) {
      widget.onUnlock();
    } else {
      setState(() {
        error = 'Mã PIN không đúng';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Nhập mã PIN", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(counterText: ""),
              ),
            ),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _validatePin, child: const Text("Mở khóa"))
          ],
        ),
      ),
    );
  }
}

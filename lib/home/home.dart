import 'package:flutter/material.dart';

void main() => runApp(const MenstrualCycleApp());

class MenstrualCycleApp extends StatelessWidget {
  const MenstrualCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chu kỳ kinh nguyệt',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🌸 Chu kỳ kinh nguyệt'),
          backgroundColor: Colors.pinkAccent,
        ),
        body: const CycleTimeline(),
      ),
    );
  }
}

class CycleTimeline extends StatelessWidget {
  const CycleTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        CycleCard(
          title: '🩸 Hành kinh',
          subtitle: 'Ngày 1–5',
          description:
          'Niêm mạc tử cung bong ra và được thải ra ngoài cơ thể. Cảm giác có thể mệt mỏi, đau bụng nhẹ.',
          color: Colors.pinkAccent,
        ),
        CycleCard(
          title: '🌱 Giai đoạn nang trứng',
          subtitle: 'Ngày 6–13',
          description:
          'Cơ thể bắt đầu tạo trứng mới, niêm mạc tử cung dày lên. Cảm giác khỏe hơn và nhiều năng lượng.',
          color: Colors.lightBlueAccent,
        ),
        CycleCard(
          title: '🌼 Rụng trứng',
          subtitle: 'Ngày 14',
          description:
          'Trứng rụng khỏi buồng trứng. Đây là thời điểm dễ thụ thai nhất. Có thể tăng ham muốn hoặc có dịch nhầy nhiều hơn.',
          color: Colors.yellowAccent,
        ),
        CycleCard(
          title: '🌙 Giai đoạn hoàng thể',
          subtitle: 'Ngày 15–28',
          description:
          'Cơ thể chuẩn bị cho thai kỳ. Nếu không thụ thai, hormone giảm và chu kỳ sẽ lặp lại. Có thể có cảm giác nhạy cảm, khó chịu (PMS).',
          color: Colors.deepPurpleAccent,
        ),
      ],
    );
  }
}

class CycleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Color color;

  const CycleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withAlpha(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 10),
            Text(description,
                style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

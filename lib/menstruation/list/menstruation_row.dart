import 'package:flutter/material.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationRow extends StatelessWidget {
  const MenstruationRow({super.key, required this.menstruation});
  final MenstruationModel menstruation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = menstruation.endTime.difference(menstruation.startTime).inDays + 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Giai đoạn hành kinh
          Row(
            children: [
              const Icon(Icons.water_drop_outlined, color: Colors.pink, size: 20),
              const SizedBox(width: 8),
              Text(
                'Giai đoạn hành kinh (${duration} ngày)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // Thời gian
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${menstruation.startTime.globalDateFormat()} → ${menstruation.endTime.globalDateFormat()}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          // Ghi chú nếu có
          if (menstruation.note.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    menstruation.note.trim(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade800,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

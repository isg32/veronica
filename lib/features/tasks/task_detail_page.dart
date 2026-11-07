import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';

/// One task: how long it has waited, due date, priority and notes.
class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider).value ?? const <Task>[];
    final task = tasks.where((t) => t.id == id).firstOrNull;
    final now = ref.watch(currentMinuteProvider);
    final repo = ref.read(taskRepositoryProvider);

    if (task == null) {
      return const VDetailPage(
        backLabel: 'Tasks',
        title: 'Task',
        children: [VFootnote('This task was deleted.')],
      );
    }
    final age = task.ageDays(now);
    final outline = TaskAgeOutline.forDays(task.isDone ? 0 : age);

    return VDetailPage(
      backLabel: 'Tasks',
      title: task.title,
      titleStyle: VText.doto(30, height: 1.05),
      action: VTextAction(
        'Rename',
        onTap: () async {
          final name = await showTextSheet(
            context,
            title: 'Rename task',
            initial: task.title,
          );
          if (name != null) await repo.update(task.copyWith(title: name));
        },
      ),
      children: [
        VCard(
          outline: outline.outline,
          borderWidth: outline.width,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.isDone ? 'Done' : VFormat.ageLong(age),
                style: VText.doto(56, weight: 900, height: 1),
              ),
              const SizedBox(height: 6),
              Text(
                task.isDone
                    ? 'finished ${VFormat.dateTime(task.completedAt!)}'
                    : 'waiting since ${VFormat.dateTime(task.createdAt)}',
                style: VText.inter(13, weight: 300),
              ),
            ],
          ),
        ),
        VListSection(
          children: [
            VListRow(
              title: 'Due',
              value: task.dueAt == null
                  ? 'None'
                  : VFormat.shortDate(task.dueAt!),
              onTap: () async {
                final picked = await showDatePickerSheet(
                  context,
                  title: 'Due date',
                  from: now,
                  initial: task.dueAt,
                );
                if (picked != null) {
                  await repo.update(task.copyWith(dueAt: picked));
                }
              },
            ),
            VListRow(
              title: 'Priority',
              trailing: VSegmented<TaskPriority>(
                compact: true,
                segments: const {
                  TaskPriority.low: 'Low',
                  TaskPriority.mid: 'Mid',
                  TaskPriority.high: 'High',
                },
                value: task.priority,
                onChanged: (p) => repo.update(task.copyWith(priority: p)),
              ),
            ),
          ],
        ),
        VCard(
          onTap: () async {
            final notes = await showTextSheet(
              context,
              title: 'Notes',
              initial: task.notes,
              placeholder: 'Add notes',
            );
            if (notes != null) await repo.update(task.copyWith(notes: notes));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VEyebrow('Notes'),
              const SizedBox(height: 12),
              Text(
                task.notes.isEmpty ? 'Tap to add notes' : task.notes,
                style: VText.inter(
                  14,
                  weight: task.notes.isEmpty ? 300 : 400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        VButton.primary(
          task.isDone ? 'Mark not done' : 'Mark done',
          onPressed: () async {
            await repo.setDone(task.id, done: !task.isDone);
            if (context.mounted && !task.isDone) context.pop();
          },
        ),
        VButton.ghost(
          'Delete',
          onPressed: () async {
            await repo.delete(task.id);
            if (context.mounted) context.pop();
          },
        ),
      ],
    );
  }
}

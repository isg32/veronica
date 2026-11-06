import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_colors.dart';
import '../../core/theme/v_text.dart';
import '../../core/theme/v_tokens.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';

enum _Filter { all, old, done }

/// Tab 3: tasks that show how long they have waited.
class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider).value ?? const <Task>[];
    final now = ref.watch(currentTimeProvider);
    final open = ref.watch(openTasksOldestFirstProvider);
    final shown = switch (_filter) {
      _Filter.all => open,
      _Filter.old => open.where((t) => t.ageDays(now) >= 3).toList(),
      _Filter.done =>
        tasks.where((t) => t.isDone).toList()
          ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!)),
    };

    return VTabPage(
      title: 'Tasks',
      trailing: VCircleButton(
        icon: VIcon.plus,
        filled: true,
        onTap: () => showAddTaskSheet(context),
      ),
      header: VSegmented<_Filter>(
        segments: {
          _Filter.all: 'All · ${open.length}',
          _Filter.old: 'Old 3+ days',
          _Filter.done: 'Done',
        },
        value: _filter,
        onChanged: (f) => setState(() => _filter = f),
      ),
      children: [
        const SizedBox(height: 4),
        for (final task in shown)
          TaskRow(key: ValueKey(task.id), task: task, now: now),
        if (shown.isEmpty)
          VFootnote(switch (_filter) {
            _Filter.all => 'Nothing waiting. Add a task with +.',
            _Filter.old => 'Nothing older than 3 days.',
            _Filter.done => 'Finished tasks show up here.',
          }),
        if (_filter != _Filter.done && shown.isNotEmpty)
          const VFootnote(
            'Outline gets heavier at 3 days and turns dashed after 7. '
            'Swipe right to complete, left to delete.',
          ),
      ],
    );
  }
}

/// A task row: age checkbox, title, age line, and the Doto age on the right.
/// Swipe right completes it, swipe left deletes it.
class TaskRow extends ConsumerWidget {
  const TaskRow({super.key, required this.task, required this.now});

  final Task task;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(taskRepositoryProvider);
    final age = task.ageDays(now);
    final outline = TaskAgeOutline.forDays(task.isDone ? 0 : age);
    final due = task.dueAt == null
        ? ''
        : ' · due ${VFormat.dayMonth(task.dueAt!)}';

    final row = VCard(
      radius: VRadius.taskRow,
      outline: outline.outline,
      borderWidth: outline.width,
      padding: const EdgeInsets.all(14),
      onTap: () => context.push(Routes.task(task.id)),
      child: Row(
        children: [
          VTappable(
            onTap: () => repo.setDone(task.id, done: !task.isDone),
            child: VTaskCheck(ageDays: age, done: task.isDone),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: VText.inter(15, weight: 500)),
                const SizedBox(height: 2),
                Text(
                  task.isDone
                      ? 'done ${VFormat.shortDate(task.completedAt!)}'
                      : '${VFormat.added(age)}$due',
                  style: VText.inter(12, weight: 300),
                ),
              ],
            ),
          ),
          if (!task.isDone && age >= 3)
            Text(VFormat.ageShort(age), style: VText.doto(18)),
        ],
      ),
    );

    return Dismissible(
      key: ValueKey('dismiss-${task.id}'),
      background: const _SwipeLayer(
        'Complete',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: const _SwipeLayer(
        'Delete',
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await repo.setDone(task.id, done: !task.isDone);
        } else {
          await repo.delete(task.id);
        }
        return true;
      },
      child: row,
    );
  }
}

class _SwipeLayer extends StatelessWidget {
  const _SwipeLayer(this.label, {required this.alignment});

  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: VColors.white,
        borderRadius: BorderRadius.circular(VRadius.taskRow),
      ),
      child: Text(
        label,
        style: VText.inter(13, weight: 600).copyWith(color: VColors.black),
      ),
    );
  }
}

/// The glass "New task" sheet. The age label starts when the task is added.
Future<void> showAddTaskSheet(BuildContext context) {
  return showVSheet<void>(
    context,
    title: 'New task',
    builder: (context) => const _AddTask(),
  );
}

class _AddTask extends ConsumerStatefulWidget {
  const _AddTask();

  @override
  ConsumerState<_AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<_AddTask> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _due;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    await ref
        .read(taskRepositoryProvider)
        .add(title: title, notes: _notes.text.trim(), dueAt: _due);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickDue() async {
    final now = ref.read(currentTimeProvider);
    final picked = await showDatePickerSheet(
      context,
      title: 'Due date',
      from: now,
      initial: _due ?? now.add(const Duration(days: 3)),
    );
    if (picked != null) setState(() => _due = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VTextField(
          controller: _title,
          placeholder: 'What needs doing?',
          autofocus: true,
          onSubmitted: (_) => _add(),
        ),
        const SizedBox(height: 14),
        VTextField(
          controller: _notes,
          placeholder: 'Add notes',
          dashed: true,
          maxLines: 3,
          style: VText.inter(14),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: Text('Due date', style: VText.rowTitle)),
            if (_due != null) ...[
              VPill(
                VFormat.shortDate(_due!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                onTap: _pickDue,
              ),
              const SizedBox(width: 8),
            ],
            VSwitch(
              value: _due != null,
              onChanged: (on) => on ? _pickDue() : setState(() => _due = null),
            ),
          ],
        ),
        const SizedBox(height: 14),
        VButton.primary('Add', onPressed: _add),
        const SizedBox(height: 14),
        Text(
          'The age label starts from when you add it.',
          textAlign: TextAlign.center,
          style: VText.secondary,
        ),
      ],
    );
  }
}

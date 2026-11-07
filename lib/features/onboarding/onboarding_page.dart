import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/v_ink.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_colors.dart';
import '../../core/theme/v_text.dart';
import '../../core/theme/v_tokens.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_wheel.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../care/water_goal_form.dart';
import '../selectors.dart';
import '../focus/watch_apps_list.dart';
import '../settings/settings_pages.dart';
import '../settings/shizuku_grant.dart';

/// First run: welcome and name, permissions, ADB, apps to watch, water goal
/// and sleep times. "Done" marks the profile onboarded, and the router moves
/// to Today.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  static const steps = 6;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pages = PageController();
  int _step = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int step) {
    setState(() => _step = step);
    _pages.animateToPage(
      step,
      duration: VMotion.standard,
      curve: VMotion.curve,
    );
  }

  void _next() => _go(_step + 1);

  Future<void> _finish(SleepSchedule schedule) async {
    await ref.read(sleepRepositoryProvider).saveSchedule(schedule);
    final repo = ref.read(profileRepositoryProvider);
    final profile = await repo.watch().first;
    await repo.save(profile.copyWith(onboarded: true));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) _go(_step - 1);
      },
      child: CupertinoPageScaffold(
        backgroundColor: VInk.surfaceOf(context),
        child: SafeArea(
          child: PageView(
            controller: _pages,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _WelcomeStep(onBegin: _next),
              _PermissionsStep(onContinue: _next),
              _AdbStep(onContinue: _next),
              _StepFrame(
                step: 4,
                title: 'Watch apps',
                body: 'Pick the apps that pull you in. Only these are tracked.',
                footer: _WatchFooter(onContinue: _next),
                child: const WatchAppsList(defaultLimitMin: 60),
              ),
              _StepFrame(
                step: 5,
                title: 'Water goal',
                body: 'How much to drink, and when Veronica may remind you.',
                footer: VButton.primary('Continue', onPressed: _next),
                child: const WaterGoalForm(),
              ),
              _SleepStep(onDone: _finish),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header ("STEP n OF 6", title, one line), scrolling content, fixed footer.
class _StepFrame extends StatelessWidget {
  const _StepFrame({
    required this.step,
    required this.title,
    required this.body,
    required this.child,
    required this.footer,
  });

  final int step;
  final String title;
  final String body;
  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STEP $step OF ${OnboardingPage.steps}',
                style: VText.eyebrow,
              ),
              const SizedBox(height: 8),
              Text(title, style: VText.title),
              const SizedBox(height: 8),
              Text(body, style: VText.inter(14, weight: 300, height: 1.45)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: child,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: footer,
        ),
      ],
    );
  }
}

class _WelcomeStep extends ConsumerStatefulWidget {
  const _WelcomeStep({required this.onBegin});

  final VoidCallback onBegin;

  @override
  ConsumerState<_WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends ConsumerState<_WelcomeStep> {
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = ref.read(profileProvider).value?.name ?? '';
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _begin() async {
    final repo = ref.read(profileRepositoryProvider);
    final profile = await repo.watch().first;
    await repo.save(profile.copyWith(name: _name.text.trim()));
    widget.onBegin();
  }

  @override
  Widget build(BuildContext context) {
    final name = _name.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 80, 28, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VERO\nNICA',
                  style: VText.doto(
                    62,
                    weight: 900,
                    height: 0.9,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'A calm companion for using your phone less and looking '
                  'after yourself more.',
                  style: VText.inter(20, weight: 300, height: 1.35),
                ),
                const SizedBox(height: 20),
                VOutlined(
                  radius: VRadius.pill,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _Waveform(),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            name.isEmpty
                                ? '"Hello. I\'m Veronica."'
                                : '"Hello, $name. I\'m Veronica."',
                            style: VText.inter(13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text('WHAT SHOULD VERONICA CALL YOU?', style: VText.eyebrow),
                const SizedBox(height: 10),
                VTextField(
                  controller: _name,
                  placeholder: 'Your name',
                  onSubmitted: (_) => _begin(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Column(
            children: [
              const _StepDots(current: 0),
              const SizedBox(height: 18),
              VButton.primary('Begin', onPressed: _begin),
            ],
          ),
        ),
      ],
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final h in const [6.0, 12.0, 16.0, 9.0, 13.0, 5.0]) ...[
            Container(width: 2, height: h, color: VInk.of(context)),
            const SizedBox(width: 3),
          ],
        ],
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < OnboardingPage.steps; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          SizedBox(
            width: i == current ? 18 : 6,
            height: 6,
            child: VOutlined(
              radius: 3,
              outline: i == current ? VOutline.none : VOutline.solid,
              fill: i == current ? VInk.of(context) : VColors.transparent,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ],
    );
  }
}

class _PermissionsStep extends ConsumerWidget {
  const _PermissionsStep({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granted = ref.watch(permissionsProvider).value ?? const {};
    final count = AppPermission.values.where((p) => granted[p] == true).length;
    final all = count == AppPermission.values.length;
    final repo = ref.read(permissionRepositoryProvider);

    return _StepFrame(
      step: 2,
      title: 'Permissions',
      body:
          'Veronica only reads what you allow. Everything stays on this phone.',
      footer: Column(
        children: [
          Text(
            '$count of ${AppPermission.values.length} granted',
            style: VText.inter(12, weight: 300),
          ),
          const SizedBox(height: 10),
          all
              ? VButton.primary('Continue', onPressed: onContinue)
              : VButton.ghost('Continue', onPressed: onContinue),
        ],
      ),
      child: VListSection(
        children: [
          for (final p in AppPermission.values)
            VListRow(
              title: p.label,
              subtitle: p.reason,
              trailing: granted[p] == true
                  ? const VCircleButton(
                      icon: VIcon.check,
                      filled: true,
                      size: 26,
                    )
                  : VPill(
                      'Grant',
                      style: VText.inter(12, weight: 600),
                      onTap: () => repo.request(p),
                    ),
            ),
        ],
      ),
    );
  }
}

class _AdbStep extends ConsumerStatefulWidget {
  const _AdbStep({required this.onContinue});

  final VoidCallback onContinue;

  @override
  ConsumerState<_AdbStep> createState() => _AdbStepState();
}

class _AdbStepState extends ConsumerState<_AdbStep> {
  bool _checking = false;

  @override
  Widget build(BuildContext context) {
    final adb = ref.watch(adbStatusProvider).value;
    final now = ref.watch(currentTimeProvider);

    Widget command({
      required String title,
      required String text,
      required bool works,
      String? note,
    }) {
      return VCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: VText.inter(13, weight: 500)),
                ),
                if (works) ...[
                  const VCircleButton(
                    icon: VIcon.check,
                    filled: true,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text('Works', style: VText.inter(12, weight: 500)),
                ] else
                  Text('Not yet', style: VText.inter(12, weight: 300)),
              ],
            ),
            const SizedBox(height: 10),
            VOutlined(
              radius: 12,
              outline: VOutline.dashed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(text, style: VText.mono),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CopyPill(text),
                const Spacer(),
                if (note != null)
                  Text(note, style: VText.inter(11, weight: 300)),
              ],
            ),
          ],
        ),
      );
    }

    final steps = [
      command(
        title: '1 · Greyscale',
        text: AdbCommands.greyscale,
        works: adb?.greyscaleGranted ?? false,
      ),
      if (adb?.glyphDebugNeeded ?? false)
        command(
          title: '2 · Glyph debug',
          text: AdbCommands.glyphDebug,
          works: adb!.glyphDebugActive(now),
          note: 'Expires after 48 h',
        ),
    ];

    return _StepFrame(
      step: 3,
      title: 'ADB setup',
      body: steps.length == 1
          ? 'Connect to a computer once and run this command. It unlocks greyscale.'
          : 'Connect to a computer once and run these two commands. They unlock '
                'greyscale and the Glyph lights.',
      footer: Column(
        children: [
          VButton.primary(
            _checking ? 'Checking…' : 'Check again',
            enabled: !_checking,
            onPressed: () async {
              setState(() => _checking = true);
              await ref.read(permissionRepositoryProvider).recheckAdb();
              if (!mounted) return;
              setState(() => _checking = false);
              final next = ref.read(adbStatusProvider).value;
              if (next != null && next.greyscaleGranted) widget.onContinue();
            },
          ),
          const SizedBox(height: 10),
          VLink(
            'Skip for now',
            onTap: widget.onContinue,
            style: VText.inter(13),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, s) in steps.indexed) ...[
            if (i > 0) const SizedBox(height: 12),
            s,
          ],
          if (!(adb?.greyscaleGranted ?? false)) ...[
            const SizedBox(height: 12),
            const ShizukuGrant(),
          ],
        ],
      ),
    );
  }
}

class _WatchFooter extends ConsumerWidget {
  const _WatchFooter({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final total = apps.fold<int>(0, (s, a) => s + a.dailyLimitMin);
    return Column(
      children: [
        Text(
          apps.isEmpty
              ? 'Pick at least one app'
              : '${VFormat.count(apps.length, 'app')} · ${VFormat.minutes(total)} a day in total',
          style: VText.inter(12, weight: 300),
        ),
        const SizedBox(height: 10),
        VButton.primary(
          'Continue',
          enabled: apps.isNotEmpty,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _SleepStep extends ConsumerStatefulWidget {
  const _SleepStep({required this.onDone});

  final Future<void> Function(SleepSchedule schedule) onDone;

  @override
  ConsumerState<_SleepStep> createState() => _SleepStepState();
}

class _SleepStepState extends ConsumerState<_SleepStep> {
  SleepSchedule? _s;

  @override
  Widget build(BuildContext context) {
    _s ??= ref.watch(sleepScheduleProvider).value;
    final s = _s;
    if (s == null) return const SizedBox.shrink();

    Widget picker(String label, DayTime t, ValueChanged<DayTime> onChanged) {
      return VCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: VText.eyebrow),
            const SizedBox(height: 12),
            VTimeWheel(
              hour: t.hour,
              minute: t.minute,
              onChanged: (h, m) => onChanged(DayTime(h, m)),
            ),
          ],
        ),
      );
    }

    return _StepFrame(
      step: 6,
      title: 'Sleep times',
      body: 'Veronica winds the phone down before bed and wakes you gently.',
      footer: VButton.primary('Done', onPressed: () => widget.onDone(s)),
      child: Column(
        children: [
          picker(
            'BEDTIME',
            s.bedtime,
            (t) => setState(() => _s = s.copyWith(bedtime: t)),
          ),
          const SizedBox(height: 12),
          picker(
            'WAKE',
            s.wake,
            (t) => setState(() => _s = s.copyWith(wake: t)),
          ),
          const SizedBox(height: 12),
          VPill.badge('${VFormat.hm(s.sleepLength)} of sleep'),
        ],
      ),
    );
  }
}

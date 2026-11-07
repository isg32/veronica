import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/providers.dart';
import '../../platform/android_usage.dart';
import '../../platform/watcher.dart';

/// Walks through what the watcher needs, one step at a time: usage access,
/// the watcher in Accessibility, then notifications. Hidden once all is set.
/// Re-checks when you come back from a settings screen.
class SetupBanner extends ConsumerStatefulWidget {
  const SetupBanner({super.key});

  @override
  ConsumerState<SetupBanner> createState() => _SetupBannerState();
}

class _SetupBannerState extends ConsumerState<SetupBanner>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(watcherSetupProvider);
      ref.invalidate(usageAccessProvider);
      ref.read(usageRepositoryProvider).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(watcherSetupProvider).value ?? WatcherSetup.ready;
    final (title, body, action) = switch (step) {
      WatcherSetup.usageAccess => (
        'Allow usage access',
        'So Veronica can see time in the apps you watch. Nothing leaves the phone.',
        UsageAccess.request,
      ),
      WatcherSetup.accessibility => (
        'Turn on the watcher',
        'In Accessibility, turn on "Veronica watcher". It only sees which app '
            'is in front, so it can show "Put it down" at your limit.',
        Watcher.openSettings,
      ),
      WatcherSetup.notifications => (
        'Allow notifications',
        'For a gentle nudge before you reach a limit.',
        () async {
          await Watcher.requestNotify();
          ref.invalidate(watcherSetupProvider);
        },
      ),
      WatcherSetup.ready => (null, null, null),
    };
    if (title == null) return const SizedBox.shrink();

    return VCard(
      inverted: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: VText.inter(14, weight: 600)),
                const SizedBox(height: 2),
                Text(body!, style: VText.inter(12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          VPill(
            step == WatcherSetup.accessibility ? 'Open' : 'Allow',
            style: VText.inter(12, weight: 600),
            onTap: action,
          ),
        ],
      ),
    );
  }
}

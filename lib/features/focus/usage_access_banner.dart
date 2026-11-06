import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/providers.dart';
import '../../platform/android_usage.dart';

/// Shown until Veronica has "Usage access". Re-checks when you come back
/// from the settings screen and re-reads minutes once it is granted.
class UsageAccessBanner extends ConsumerStatefulWidget {
  const UsageAccessBanner({super.key});

  @override
  ConsumerState<UsageAccessBanner> createState() => _UsageAccessBannerState();
}

class _UsageAccessBannerState extends ConsumerState<UsageAccessBanner>
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
      ref.invalidate(usageAccessProvider);
      ref.read(usageRepositoryProvider).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final granted = ref.watch(usageAccessProvider).value ?? true;
    if (granted) return const SizedBox.shrink();
    return VCard(
      inverted: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Allow usage access', style: VText.inter(14, weight: 600)),
                const SizedBox(height: 2),
                Text(
                  'So Veronica can see time in the apps you watch. Nothing '
                  'leaves the phone.',
                  style: VText.inter(12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          VPill(
            'Allow',
            style: VText.inter(12, weight: 600),
            onTap: UsageAccess.request,
          ),
        ],
      ),
    );
  }
}

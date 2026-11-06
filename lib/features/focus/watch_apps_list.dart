import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_colors.dart';
import '../../core/theme/v_text.dart';
import '../../core/theme/v_tokens.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_ink.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Searchable list of installed apps with a switch to watch each one.
/// Used in onboarding ("Watch apps") and Focus ("Add app").
class WatchAppsList extends ConsumerStatefulWidget {
  const WatchAppsList({super.key, this.defaultLimitMin = 30});

  final int defaultLimitMin;

  @override
  ConsumerState<WatchAppsList> createState() => _WatchAppsListState();
}

class _WatchAppsListState extends ConsumerState<WatchAppsList> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final installed =
        ref.watch(installedAppsProvider).value ?? const <InstalledApp>[];
    final watched = {
      for (final w
          in ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[])
        w.packageName: w,
    };
    final query = _search.text.trim().toLowerCase();
    final shown = installed
        .where((a) => query.isEmpty || a.name.toLowerCase().contains(query))
        .toList();
    final repo = ref.read(usageRepositoryProvider);
    final ink = VInk.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VOutlined(
          radius: VRadius.pill,
          child: CupertinoTextField(
            controller: _search,
            placeholder: 'Search ${VFormat.count(installed.length, 'app')}',
            placeholderStyle: VText.inter(14, weight: 300).copyWith(color: ink),
            style: VText.inter(14).copyWith(color: ink),
            cursorColor: ink,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
            prefix: const Padding(
              padding: EdgeInsets.only(left: 16, right: 4),
              child: VIconView(VIcon.search, size: 16, strokeWidth: 1.6),
            ),
            decoration: const BoxDecoration(color: VColors.transparent),
          ),
        ),
        const SizedBox(height: 12),
        VListSection(
          children: [
            for (final app in shown)
              VListRow(
                leading: VAppTile(app.name),
                title: app.name,
                subtitle: watched[app.packageName] == null
                    ? 'Not watched'
                    : 'Limit ${watched[app.packageName]!.dailyLimitMin} min a day',
                trailing: VSwitch(
                  value: watched.containsKey(app.packageName),
                  onChanged: (on) => on
                      ? repo.watch(app, dailyLimitMin: widget.defaultLimitMin)
                      : repo.unwatch(app.packageName),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

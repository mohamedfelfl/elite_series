import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Responsive layout wrapper that adapts between mobile and desktop.
///
/// On desktop (≥ 900px): Shows a navigation rail on the side + expanded content.
/// On mobile (< 900px): Full-width content with drawer navigation.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? desktopBody;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationRailDestination> destinations;
  final Widget? leading;

  static const double breakpoint = 800;

  final bool isCollapsed;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.desktopBody,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.isCollapsed = false,
    this.leading,
    this.trailing,
  });

  final Widget? trailing;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= breakpoint;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < breakpoint;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= breakpoint) {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(5, 0),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: selectedIndex,
                        onDestinationSelected: onDestinationSelected,
                        destinations: destinations,
                        labelType: isCollapsed
                            ? NavigationRailLabelType.none
                            : (width >= 1200
                                  ? NavigationRailLabelType.none
                                  : NavigationRailLabelType.all),
                        selectedLabelTextStyle: GoogleFonts.cairo(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                        unselectedLabelTextStyle: GoogleFonts.cairo(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: 0.2,
                        ),
                        indicatorShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: leading,
                        trailing: trailing,
                        extended: !isCollapsed && width >= 1200,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: desktopBody ?? mobileBody),
        ],
      );
    }

    return mobileBody;
  }
}

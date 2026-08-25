import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'tabs/assistant_attendance_tab.dart';

@RoutePage()
class AssistantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> assistant;

  const AssistantDetailScreen({super.key, required this.assistant});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(assistant['name']),
          bottom: const TabBar(
            tabs: [Tab(icon: Icon(Icons.co_present), text: 'Attendance')],
          ),
        ),
        body: TabBarView(
          children: [
            AssistantAttendanceTab(assistantId: assistant['id'] as int),
          ],
        ),
      ),
    );
  }
}

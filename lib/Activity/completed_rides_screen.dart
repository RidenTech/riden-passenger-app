import 'package:flutter/material.dart';
import 'activities.dart';

class CompletedRidesScreen extends StatelessWidget {
  const CompletedRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivitiesScreen(initialTab: ActivityTab.completed);
  }
}

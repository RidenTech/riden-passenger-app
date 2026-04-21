import 'package:flutter/material.dart';
import 'activities.dart';

class CancelledRidesScreen extends StatelessWidget {
  const CancelledRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivitiesScreen(initialTab: ActivityTab.cancelled);
  }
}

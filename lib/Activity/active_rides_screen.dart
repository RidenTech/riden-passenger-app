import 'package:flutter/material.dart';
import 'activities.dart';

class ActiveRidesScreen extends StatelessWidget {
  const ActiveRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivitiesScreen(initialTab: ActivityTab.active);
  }
}

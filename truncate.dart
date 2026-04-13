import 'dart:io';

void main() {
  final file = File('lib/my_profile/ProfileSettingBottomSheet.dart');
  final lines = file.readAsLinesSync();
  file.writeAsStringSync(lines.take(416).join('\n') + '\n');
}

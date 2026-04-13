import sys

with open('lib/my_profile/ProfileSettingBottomSheet.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

with open('lib/my_profile/ProfileSettingBottomSheet.dart', 'w', encoding='utf-8') as f:
    f.writelines(lines[:416])

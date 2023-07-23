import 'package:flutter/material.dart';

class InteractiveSettingTile extends StatelessWidget {
  const InteractiveSettingTile({
    required this.title,
    required this.currentValue,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String currentValue;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(currentValue),
      trailing: enabled ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}

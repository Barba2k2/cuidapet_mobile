import 'package:flutter/material.dart';

import '../../../core/ui/extension/theme_extension.dart';

class SupplierServiceWidget extends StatelessWidget {
  const SupplierServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.pets_rounded),
      ),
      title: const Text('Banho'),
      subtitle: const Text('R\$ 50,00'),
      trailing: Icon(
        Icons.add_circle_rounded,
        size: 30,
        color: context.primaryColor,
      ),
    );
  }
}

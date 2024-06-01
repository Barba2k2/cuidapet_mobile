import 'package:flutter/material.dart';

import '../../../core/helpers/text_formatter.dart';
import '../../../core/ui/extension/theme_extension.dart';
import '../../../models/supplier_services_model.dart';

class SupplierServiceWidget extends StatelessWidget {
  final SupplierServicesModel service;

  const SupplierServiceWidget({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.pets_rounded),
      ),
      title: Text(service.name),
      subtitle: Text(
        TextFormatter.formatReal(service.price),
      ),
      trailing: Icon(
        Icons.add_circle_rounded,
        size: 30,
        color: context.primaryColor,
      ),
    );
  }
}

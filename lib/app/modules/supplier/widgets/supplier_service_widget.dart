import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/helpers/text_formatter.dart';
import '../../../core/ui/extension/theme_extension.dart';
import '../../../models/supplier_services_model.dart';
import '../supplier_controller.dart';

class SupplierServiceWidget extends StatelessWidget {
  final SupplierServicesModel service;
  final SupplierController supplierController;

  const SupplierServiceWidget({
    super.key,
    required this.service,
    required this.supplierController,
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
      trailing: Observer(
        builder: (_) {
          return IconButton(
            onPressed: () {
              supplierController.addOrRemoveServices(service);
            },
            icon: supplierController.isServiceSelected(service)
                ? const Icon(
                    Icons.remove_circle_rounded,
                    size: 30,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.add_circle_rounded,
                    size: 30,
                    color: context.primaryColor,
                  ),
          );
        },
      ),
    );
  }
}

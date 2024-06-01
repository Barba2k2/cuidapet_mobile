import 'package:flutter/material.dart';

import '../../../core/ui/extension/theme_extension.dart';
import '../../../models/supplier_model.dart';
import '../supplier_controller.dart';

class SupplierDetail extends StatelessWidget {
  final SupplierModel supplier;
  final SupplierController controller;

  const SupplierDetail({
    super.key,
    required this.supplier,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          child: Center(
            child: Text(
              supplier.name,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: context.primaryColor,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Informações do estabelecimento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ListTile(
          onTap: controller.goToGeoOrCopyAddressToClipart,
          leading: const Icon(
            Icons.location_city_rounded,
            color: Colors.black,
          ),
          title: Text(supplier.address),
        ),
        ListTile(
          onTap: controller.goToPhoneOrCopyPhoneToClipart,
          leading: const Icon(
            Icons.local_phone_rounded,
            color: Colors.black,
          ),
          title: Text(supplier.phone),
        ),
      ],
    );
  }
}

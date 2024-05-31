import 'package:flutter/material.dart';

import '../../../core/ui/extension/theme_extension.dart';

class SupplierDetail extends StatelessWidget {
  const SupplierDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          child: Center(
            child: Text(
              'Clinica Central ABC',
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
            'Informações do estabelicimento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.location_city_rounded,
            color: Colors.black,
          ),
          title: Text('Rua das Palmeiras, 123'),
        ),
        const ListTile(
          leading: Icon(
            Icons.local_phone_rounded,
            color: Colors.black,
          ),
          title: Text('(12) 3554-3554'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../../core/ui/extension/size_screen_extension.dart';
import '../../../core/ui/extension/theme_extension.dart';
import '../../../core/ui/widgets/cuidapet_default_button.dart';
import '../../../models/place_model.dart';
import 'address_detail_controller.dart';

class AddressDetailPage extends StatefulWidget {
  final PlaceModel place;

  const AddressDetailPage({super.key, required this.place});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  final _additionalEC = TextEditingController();
  final controller = Modular.get<AddressDetailController>();
  late final ReactionDisposer addressEntityDisposer;

  @override
  void initState() {
    super.initState();
    addressEntityDisposer = reaction(
      (_) => controller.addressEntity,
      (addressEntity) {
        if (addressEntity != null) {
          Navigator.pop(context, addressEntity);
        }
      },
    );
  }

  @override
  void dispose() {
    _additionalEC.dispose();
    addressEntityDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.primaryColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text(
            'Confirme seu endereço',
            style: context.textTheme.headline5?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GoogleMap(
              buildingsEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.place.lat,
                  widget.place.lng,
                ),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('AddressID'),
                  position: LatLng(
                    widget.place.lat,
                    widget.place.lng,
                  ),
                  infoWindow: InfoWindow(
                    title: widget.place.address,
                  ),
                ),
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              readOnly: true,
              initialValue: widget.place.address,
              decoration: InputDecoration(
                labelText: 'Endereço',
                suffixIcon: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(widget.place);
                  },
                  icon: const Icon(Icons.edit_location_alt),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Complemento',
              ),
              controller: _additionalEC,
            ),
          ),
          SizedBox(
            width: .9.sw,
            height: 60.h,
            child: CuidapetDefaultButton(
              label: 'Salvar',
              onPressed: () {
                controller.saveAddress(
                  widget.place,
                  _additionalEC.text,
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

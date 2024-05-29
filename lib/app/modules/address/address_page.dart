import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

import '../../core/mixin/location_mixin.dart';
import '../../core/ui/extension/theme_extension.dart';
import '../../life_cycle/page_life_cycle_state.dart';
import '../../models/place_model.dart';
import 'address_controller.dart';
import 'widgets/address_search_widget/address_search_controller.dart';

part 'widgets/address_item.dart';
part 'widgets/address_search_widget/address_search_widget.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState
    extends PageLifeCycleState<AddressController, AddressPage>
    with LocationMixin {
  final reactionDiposers = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    final reactionService =
        reaction<bool>((_) => controller.locationServiceUnavailable,
            (locationServiceUnavailable) {
      if (locationServiceUnavailable) {
        showDialogLocationServiceUnavailable();
      }
    });

    final reactionLocationPermission = reaction<LocationPermission?>(
        (_) => controller.locationPermission, (locationPermission) {
      if (locationPermission != null &&
          locationPermission == LocationPermission.denied) {
        showDialogLocationDenied(tryAgain: () => controller.myLocation());
      } else if (locationPermission != null &&
          locationPermission == LocationPermission.deniedForever) {
        showDialogLocationDeniedForever();
      }
    });

    reactionDiposers.addAll(
      [
        reactionService,
        reactionLocationPermission,
      ],
    );
  }

  @override
  void dispose() {
    for (var reaction in reactionDiposers) {
      reaction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.primaryColorDark,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Text(
                'Adione ou escolha um endereço',
                style: context.textTheme.headline4?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _AddressSearchWidget(
                addressSelectedCallback: (place) {
                  controller.goToAddressDetail(place);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                onTap: () => controller.myLocation(),
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30,
                  child: Icon(
                    Icons.near_me_rounded,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Localização atual',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              const SizedBox(
                height: 20,
              ),
              Observer(
                builder: (_) {
                  return Column(
                    children: controller.addresses
                        .map(
                          (a) => _ItemTile(
                            address: a.address,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

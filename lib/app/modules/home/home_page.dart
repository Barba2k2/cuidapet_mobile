import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/ui/extension/size_screen_extension.dart';
import '../../core/ui/extension/theme_extension.dart';
import '../../entity/address_entity.dart';
import '../../life_cycle/page_life_cycle_state.dart';
import '../../models/supplier_category_model.dart';
import '../../models/supplier_nearby_me_model.dart';
import 'home_controller.dart';
import 'widgets/home_appbar.dart';

part 'widgets/home_address_widget.dart';
part 'widgets/home_categories_widget.dart';
part 'widgets/home_supplier_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLifeCycleState<HomeController, HomePage> {
  AddressEntity? addressEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            HomeAppBar(controller),
            SliverToBoxAdapter(
              child: _HomeAddressWidget(
                controller: controller,
              ),
            ),
            SliverToBoxAdapter(
              child: _HomeCategoriesWidget(controller),
            ),
          ];
        },
        body: _HomeSupplierTab(
          homeController: controller,
        ),
      ),
    );
  }
}

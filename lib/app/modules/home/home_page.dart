import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/ui/extension/theme_extension.dart';
import '../../entity/address_entity.dart';
import '../../life_cycle/page_life_cycle_state.dart';
import 'home_controller.dart';
import 'widgets/home_appbar.dart';

part 'widgets/home_address_widget.dart';
part 'widgets/home_categories_widget.dart';

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
            const SliverToBoxAdapter(
              child: _HomeCategoriesWidget(),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
          ),
          child: const Center(
            child: Text(
              'Home Page',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 32,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

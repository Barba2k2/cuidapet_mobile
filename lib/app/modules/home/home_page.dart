import 'package:flutter/material.dart';

import '../../entity/address_entity.dart';
import '../../life_cycle/page_life_cycle_state.dart';
import 'home_controller.dart';
import 'widgets/home_appbar.dart';

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
            HomeAppBar(),
          ];
        },
        body: const Center(
          child: Text('Home Page'),
        ),
      ),
    );
  }
}

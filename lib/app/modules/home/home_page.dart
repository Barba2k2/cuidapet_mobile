import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/rest_client/rest_client.dart';
import '../../life_cycle/page_life_cycle_state.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLifeCycleState<HomeController, HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () async {
                final categoriesResponse =
                    await Modular.get<RestClient>().auth().get('/categories/');
                log(categoriesResponse.data);
              },
              child: const Text('Update Refresh Token'),
            ),
          ],
        ),
      ),
    );
  }
}

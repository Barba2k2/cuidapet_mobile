import 'package:flutter/material.dart';

import '../../../core/ui/extension/size_screen_extension.dart';
import '../../../core/ui/extension/theme_extension.dart';

class HomeAppBar extends SliverAppBar {
  HomeAppBar({super.key})
      : super(
          expandedHeight: 100,
          collapsedHeight: 100,
          elevation: 0,
          flexibleSpace: _CuidapetAppBar(),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          pinned: true,
        );
}

class _CuidapetAppBar extends StatelessWidget {
  // const _CuidapetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final outlineInoutBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: Colors.grey[200]!,
      ),
    );

    return AppBar(
      backgroundColor: Colors.grey[100],
      centerTitle: true,
      title: const Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: Text('Cuidapet'),
      ),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.location_on_rounded,
            color: Colors.black,
          ),
        ),
      ],
      flexibleSpace: Stack(
        children: [
          Container(
            height: 110.h,
            color: context.primaryColor,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: .9.sw,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(30),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(
                      Icons.search_rounded,
                      size: 26,
                      color: Colors.grey,
                    ),
                    border: outlineInoutBorder,
                    focusedBorder: outlineInoutBorder,
                    enabledBorder: outlineInoutBorder,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

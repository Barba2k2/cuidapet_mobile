import 'package:flutter/material.dart';

import '../../core/ui/extension/theme_extension.dart';
import 'widgets/supplier_detail.dart';
import 'widgets/supplier_service_widget.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  late ScrollController _scrollController;
  bool sliverCollapesed = false;
  ValueNotifier<bool> sliverCollapsedVN = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        if (_scrollController.offset > 180 &&
            !_scrollController.position.outOfRange) {
          sliverCollapsedVN.value = true;
        } else if (_scrollController.offset <= 180 &&
            !_scrollController.position.outOfRange) {
          sliverCollapsedVN.value = false;
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text(
          'Realizar Agendamento',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.schedule_rounded),
        backgroundColor: context.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            centerTitle: true,
            title: ValueListenableBuilder<bool>(
              valueListenable: sliverCollapsedVN,
              builder: (_, sliverCollapesedValue, child) {
                return Visibility(
                  visible: sliverCollapesedValue,
                  child: const Text(
                    'Pet Shop do Guaxinim',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Image.network(
                'https://grafufs.wordpress.com/wp-content/uploads/2019/08/guaxinim.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SupplierDetail(),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Serviços (0 selecionados)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1000,
              (context, index) {
                return const SupplierServiceWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}

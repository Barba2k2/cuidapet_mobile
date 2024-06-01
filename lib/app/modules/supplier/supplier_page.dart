import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/ui/extension/theme_extension.dart';
import '../../life_cycle/page_life_cycle_state.dart';
import 'supplier_controller.dart';
import 'widgets/supplier_detail.dart';
import 'widgets/supplier_service_widget.dart';

class SupplierPage extends StatefulWidget {
  final int _supplierId;

  const SupplierPage({
    super.key,
    required int supplierId,
  }) : _supplierId = supplierId;

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState
    extends PageLifeCycleState<SupplierController, SupplierPage> {
  late ScrollController _scrollController;
  bool sliverCollapesed = false;
  ValueNotifier<bool> sliverCollapsedVN = ValueNotifier(false);

  @override
  Map<String, dynamic>? get params => {
        'supplierId': widget._supplierId,
      };

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
      floatingActionButton: Observer(
        builder: (_) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.totalServicesSelected > 0 ? 1 : 0,
            child: FloatingActionButton.extended(
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
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Observer(
        builder: (_) {
          final supplier = controller.supplierModel;

          if (supplier == null) {
            return const Text('Buscando dados do fornecedor...');
          }

          return CustomScrollView(
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
                      child: Text(
                        supplier.name,
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
                    supplier.logo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SupplierDetail(
                  supplier: supplier,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Serviços (${controller.totalServicesSelected} selecionado${controller.totalServicesSelected > 1 ? 's' : ''})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: controller.supplierServices.length,
                  (context, index) {
                    final service = controller.supplierServices[index];
                    return SupplierServiceWidget(
                      service: service,
                      supplierController: controller,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

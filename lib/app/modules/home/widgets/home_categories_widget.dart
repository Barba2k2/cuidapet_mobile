part of '../home_page.dart';

class _HomeCategoriesWidget extends StatelessWidget {
  final HomeController _controller;
  const _HomeCategoriesWidget(this._controller);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Observer(
        builder: (_) {
          return Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _controller.listCategories.length,
              itemBuilder: (context, index) {
                final category = _controller.listCategories[index];
                return _CategroyItem(category);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategroyItem extends StatelessWidget {
  final SupplierCategoryModel _categoryModel;

  static const categoriesIcons = {
    'P': Icons.pets_rounded,
    'V': Icons.local_hospital_rounded,
    'C': Icons.store_mall_directory_rounded,
  };

  const _CategroyItem(this._categoryModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: context.primaryColorLight,
            radius: 30,
            child: Icon(
              categoriesIcons[_categoryModel.type],
              size: 30,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(_categoryModel.name),
        ],
      ),
    );
  }
}

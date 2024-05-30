part of '../home_page.dart';

class _HomeCategoriesWidget extends StatelessWidget {
  const _HomeCategoriesWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 15,
        itemBuilder: (context, index) {
          return const _CategroyItem();
        },
      ),
    );
  }
}

class _CategroyItem extends StatelessWidget {
  const _CategroyItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: context.primaryColorLight,
            radius: 30,
            child: const Icon(
              Icons.pets_rounded,
              size: 30,
              color: Colors.black,
            ),
          ),
          const Text('Petshop'),
        ],
      ),
    );
  }
}

part of '../address_page.dart';

class _AddressItem extends StatelessWidget {
  const _AddressItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Icon(
            Icons.location_on_rounded,
            color: Colors.black,
          ),
        ),
        title: Text('Rua das Flores, 123'),
        subtitle: Text('Complemento XYZ'),
      ),
    );
  }
}

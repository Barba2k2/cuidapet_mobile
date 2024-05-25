part of '../address_page.dart';

class _AddressSearchWidget extends StatefulWidget {
  const _AddressSearchWidget({Key? key}) : super(key: key);

  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        style: BorderStyle.none,
      ),
    );

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: TypeAheadFormField<PlaceModel>(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            border: border,
            disabledBorder: border,
            enabledBorder: border,
            focusedBorder: border,
            hintText: 'Insira um endereço',
            prefixIcon: const Icon(
              Icons.location_on_rounded,
            ),
          ),
        ),
        itemBuilder: (_, item) {
          log(item.address);
          return _ItemTile(
            address: item.address,
          );
        },
        onSuggestionSelected: _onSuggestionSelected,
        suggestionsCallback: _suggestionsCallback,
      ),
    );
  }

  FutureOr<Iterable<PlaceModel>> _suggestionsCallback(String pattern) {
    log('Endereco digitado: $pattern');
    return [
      PlaceModel(
        address: 'Rua das Flores, 123',
        lat: 0,
        lng: 0,
      ),
    ];
  }

  void _onSuggestionSelected(PlaceModel suggestion) {}
}

class _ItemTile extends StatelessWidget {
  final String address;

  const _ItemTile({required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on_rounded),
      title: Text(address),
    );
  }
}

part of '../../address_page.dart';

typedef AddressSelectedCallback = void Function(PlaceModel place);

class _AddressSearchWidget extends StatefulWidget {
  final AddressSelectedCallback addressSelectedCallback;
  final PlaceModel? place;

  const _AddressSearchWidget({
    super.key,
    required this.addressSelectedCallback,
    required this.place,
  });

  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  final searchTextEC = TextEditingController();
  final seachTextFN = FocusNode();

  final controller = Modular.get<AddressSearchController>();

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      searchTextEC.text = widget.place?.address ?? '';
      seachTextFN.requestFocus();
    }
  }

  @override
  void dispose() {
    searchTextEC.dispose();
    seachTextFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        style: BorderStyle.none,
      ),
    );

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: TypeAheadFormField<PlaceModel>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: searchTextEC,
          focusNode: seachTextFN,
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

  Future<List<PlaceModel>> _suggestionsCallback(String pattern) async {
    if (pattern.isNotEmpty) {
      return controller.searchAddress(pattern);
    }

    return <PlaceModel>[];
  }

  void _onSuggestionSelected(PlaceModel suggestion) {
    searchTextEC.text = suggestion.address;
    widget.addressSelectedCallback(suggestion);
  }
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

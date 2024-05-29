import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

typedef TryAgain = void Function();

mixin LocationMixin<E extends StatefulWidget> on State<E> {
  void showDialogLocationServiceUnavailable() {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: const Text('Precisamos de localização'),
          content: const Text(
            'Para realizar a busca se localização, precisamos que você ative seu GPS.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                Geolocator.openLocationSettings();
              },
              child: const Text('Abrir configurações.'),
            ),
          ],
        );
      },
    );
  }

  void showDialogLocationDenied({TryAgain? tryAgain}) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: const Text('Precisamos de Autorização'),
          content: const Text(
            'Para realizar a busca se localização, precisamos que você autorize a utilizção.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                Geolocator.openLocationSettings();
              },
              child: const Text('Abrir configurações.'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                if (tryAgain != null) {
                  tryAgain();
                }
              },
              child: const Text('Tentar novamente.'),
            ),
          ],
        );
      },
    );
  }

  void showDialogLocationDeniedForever() {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: const Text('Precisamos de Autorização'),
          content: const Text(
            'Para realizar a busca se localização, precisamos que você autorize a utilizção.Clique no botão abrir configurações e autorize a utilização da localização atual',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                Geolocator.openLocationSettings();
              },
              child: const Text('Abrir configurações.'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                Geolocator.openAppSettings();
              },
              child: const Text('Tentar novamente.'),
            ),
          ],
        );
      },
    );
  }
}

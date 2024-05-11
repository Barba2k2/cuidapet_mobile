import 'package:flutter/material.dart';

import '../../../core/ui/extension/size_screen_extension.dart';
import '../../../core/ui/widgets/cuidapet_default_button.dart';
import '../../../core/ui/widgets/cuidapet_text_form_field.dart';

part 'widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Usuario'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Image.asset(
                  'assets/images/3.0x/logo.png',
                  width: 162,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const _RegisterForm()
            ],
          ),
        ),
      ),
    );
  }
}

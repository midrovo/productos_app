import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decoration.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250,),

              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headlineMedium,),

                    const SizedBox(height: 30,),
                    
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 30,),

              const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

              const SizedBox(height: 15,),
            ],
          ),
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: "jon.doe@gmail.com",
                labelText: "Correo Electronico",
                prefixIcon: Icons.alternate_email_sharp
              ),
              onChanged: (value) => loginForm.email = value,
              validator: ( value ) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);

                return regExp.hasMatch( value ?? "") ? null : "Ingrese un correo valido";
              },
            ),

            const SizedBox(height: 30,),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: "●●●●●●●●",
                labelText: "Contrasena",
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.pass = value,
              validator: ( value ) {
                return (value != null && value.length >= 6) ? null : "La contrasena debe ser de 6 caracteres";
              },
            ),

            const SizedBox(height: 30,),
            
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading ? null : () async {

                FocusScope.of(context).unfocus();

                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                await Future.delayed(const Duration(seconds: 2));

                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, 'home');
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(loginForm.isLoading ? 'ESPERE...' : 'INGRESAR', style: const TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}

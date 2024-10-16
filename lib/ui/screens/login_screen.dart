import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/cliente_bloc.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final clienteBloc = Provider.of<ClienteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de texto para el correo electrónico
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Campo de texto para la contraseña
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  } else if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Mostrar indicador de carga si está en progreso
              if (clienteBloc.isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () {
                    // Validar los campos antes de iniciar sesión
                    if (_formKey.currentState!.validate()) {
                      clienteBloc
                          .loginCliente(
                              emailController.text, passwordController.text)
                          .then((_) {
                        if (clienteBloc.isLoggedIn) {
                          // Navegar a la pantalla de cuentas de ahorro si el login fue exitoso
                          Navigator.pushReplacementNamed(
                              context, '/cuentas_ahorro');
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al iniciar sesión: $error')),
                        );
                      });
                    }
                  },
                  child: Text('Iniciar Sesión'),
                ),
              SizedBox(height: 20),
              // Mostrar error si ocurrió durante el login
              if (clienteBloc.error != null)
                Text(
                  clienteBloc.error!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              // Botón para ir a la pantalla de registro
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registro');
                },
                child: Text('¿No tienes cuenta? Regístrate aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/registro_bloc.dart';

class RegistroScreen extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registroBloc = Provider.of<RegistroBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para el nombre
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            // Campo de texto para el correo electrónico
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            // Campo de texto para la contraseña
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Mostrar indicador de carga si está en progreso
            if (registroBloc.isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  // Intentar registrar un nuevo cliente
                  registroBloc
                      .registrarCliente(
                    nombreController.text,
                    emailController.text,
                    passwordController.text,
                  )
                      .then((_) {
                    if (registroBloc.cliente != null) {
                      // Navegar a la pantalla de inicio de sesión después del registro exitoso
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al registrar: $error')),
                    );
                  });
                },
                child: Text('Registrar'),
              ),
            SizedBox(height: 20),
            // Mostrar error si ocurrió durante el registro
            if (registroBloc.error != null)
              Text(
                registroBloc.error!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            // Botón para volver a la pantalla de inicio de sesión
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('¿Ya tienes una cuenta? Inicia sesión aquí'),
            ),
          ],
        ),
      ),
    );
  }
}

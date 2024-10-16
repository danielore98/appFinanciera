import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/cliente_bloc.dart';
import 'logic/registro_bloc.dart';
import 'logic/cuenta_ahorro_bloc.dart';
import 'logic/prestamo_bloc.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/registro_screen.dart';
import 'ui/screens/cuenta_ahorro_screen.dart';
import 'ui/screens/prestamo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteBloc()), // Bloc para el cliente
        ChangeNotifierProvider(create: (_) => RegistroBloc()), // Bloc para el registro de clientes
        ChangeNotifierProvider(create: (_) => CuentaAhorroBloc()), // Bloc para las cuentas de ahorro
        ChangeNotifierProvider(create: (_) => PrestamoBloc()), // Bloc para los préstamos
      ],
      child: MaterialApp(
        title: 'Banco Confianza App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),           // Pantalla de inicio de sesión
          '/registro': (context) => RegistroScreen(), // Pantalla de registro
          '/cuentas_ahorro': (context) => CuentasAhorroScreen(), // Pantalla de cuentas de ahorro
          '/prestamos': (context) => PrestamoScreen(), // Pantalla de préstamos
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

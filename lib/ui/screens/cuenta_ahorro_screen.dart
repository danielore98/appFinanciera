import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/cuenta_ahorro_bloc.dart';

class CuentasAhorroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cuentaAhorroBloc = Provider.of<CuentaAhorroBloc>(context);
    
    // Iniciar la carga de cuentas al entrar en la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = "your_token_here"; // Obtén el token desde donde lo tengas almacenado, por ejemplo, SharedPreferences
      cuentaAhorroBloc.obtenerCuentasAhorro();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuentas de Ahorro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar indicador de carga mientras se obtienen los datos
            if (cuentaAhorroBloc.isLoading)
              Center(child: CircularProgressIndicator()),

            // Mostrar el mensaje de error si existe
            if (cuentaAhorroBloc.error != null)
              Text(
                'Error: ${cuentaAhorroBloc.error}',
                style: TextStyle(color: Colors.red),
              ),

            // Mostrar mensaje si no se encontraron cuentas de ahorro
            if (!cuentaAhorroBloc.isLoading &&
                cuentaAhorroBloc.error == null &&
                cuentaAhorroBloc.cuentasAhorro.isEmpty)
              Text('No se encontraron cuentas de ahorro'),

            // Mostrar la lista de cuentas de ahorro si hay datos
            if (!cuentaAhorroBloc.isLoading &&
                cuentaAhorroBloc.cuentasAhorro.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: cuentaAhorroBloc.cuentasAhorro.length,
                  itemBuilder: (context, index) {
                    final cuenta = cuentaAhorroBloc.cuentasAhorro[index];
                    return Card(
                      child: ListTile(
                        title: Text('Cuenta ID: ${cuenta.id}'),
                        subtitle: Text('Saldo: ${cuenta.saldo.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRegistrarCuentaDialog(context, cuentaAhorroBloc);
        },
        child: Icon(Icons.add),
        tooltip: 'Registrar Nueva Cuenta de Ahorro',
      ),
    );
  }

  // Dialog para registrar una nueva cuenta de ahorro
  void _showRegistrarCuentaDialog(BuildContext context, CuentaAhorroBloc cuentaAhorroBloc) {
    final TextEditingController saldoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar Nueva Cuenta de Ahorro'),
          content: TextField(
            controller: saldoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Saldo Inicial',
              hintText: 'Ingrese el saldo inicial',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin acción
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final saldoInicial = double.tryParse(saldoController.text);
                if (saldoInicial != null && saldoInicial > 0) {
                  final token = "your_token_here"; // Obtén el token desde donde lo tengas almacenado

                  cuentaAhorroBloc
                      .registrarCuentaAhorro(saldoInicial)
                      .then((_) {
                    //Navigator.of(context).pop(); // Cerrar el diálogo después de registrar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Cuenta registrada con éxito'),
                    ));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error al registrar la cuenta: $error'),
                    ));
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Ingrese un saldo inicial válido'),
                  ));
                }
              },
              child: Text('Registrar'),
            ),
          ],
        );
      },
    );
  }
}

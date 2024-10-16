import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/prestamo_bloc.dart';

class PrestamoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prestamoBloc = Provider.of<PrestamoBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuentas de Préstamo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (prestamoBloc.isLoading)
              Center(child: CircularProgressIndicator()), // Mostrar indicador de carga
            if (prestamoBloc.error != null)
              Text(
                'Error: ${prestamoBloc.error}', // Mostrar el mensaje de error
                style: TextStyle(color: Colors.red),
              ),
            if (!prestamoBloc.isLoading &&
                prestamoBloc.error == null &&
                prestamoBloc.prestamos.isEmpty)
              Text('No se encontraron cuentas de préstamo'),
            if (!prestamoBloc.isLoading &&
                prestamoBloc.prestamos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: prestamoBloc.prestamos.length,
                  itemBuilder: (context, index) {
                    final prestamo = prestamoBloc.prestamos[index];
                    return Card(
                      child: ListTile(
                        title: Text('Préstamo ID: ${prestamo.id}'),
                        subtitle: Text(
                            'Monto: ${prestamo.montoPrestamo.toStringAsFixed(2)}, Saldo pendiente: ${prestamo.saldoPendiente.toStringAsFixed(2)}'),
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
          _showSolicitarPrestamoDialog(context, prestamoBloc);
        },
        child: Icon(Icons.add),
        tooltip: 'Solicitar Préstamo',
      ),
    );
  }

  // Dialog para solicitar un nuevo préstamo
  void _showSolicitarPrestamoDialog(
      BuildContext context, PrestamoBloc prestamoBloc) {
    final TextEditingController montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Solicitar Nuevo Préstamo'),
          content: TextField(
            controller: montoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Monto del Préstamo'),
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
                final monto = double.tryParse(montoController.text);
                if (monto != null && monto > 0) {
                  prestamoBloc
                      .solicitarPrestamo(monto, "your_token_here")
                      .then((_) {
                    Navigator.of(context).pop(); // Cerrar el diálogo después de registrar
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error al solicitar préstamo: $error'),
                    ));
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Ingrese un monto válido'),
                  ));
                }
              },
              child: Text('Solicitar'),
            ),
          ],
        );
      },
    );
  }
}

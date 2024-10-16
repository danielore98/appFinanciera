import 'package:flutter/material.dart';

// Botón personalizado reutilizable
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor, // Cambio de `primary` a `backgroundColor` en ElevatedButton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Campo de texto personalizado reutilizable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
        ),
      ),
      validator: validator,
    );
  }
}

// Widget personalizado para mostrar mensajes de error
class ErrorMessage extends StatelessWidget {
  final String? error;

  const ErrorMessage({this.error, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return error != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              error!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14.0,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

// Widget personalizado para mostrar un mensaje de éxito
class SuccessMessage extends StatelessWidget {
  final String message;

  const SuccessMessage({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 14.0,
        ),
      ),
    );
  }
}

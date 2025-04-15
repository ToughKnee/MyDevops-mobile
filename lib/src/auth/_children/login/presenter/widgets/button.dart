import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final Text text;
  final bool isEnabled;
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      onPressed: isEnabled? () {
        onPressed();
      }: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Center(
        child: text,
      ),
    );
  }
}

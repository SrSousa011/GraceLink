import 'package:flutter/material.dart';

class DonateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const DonateButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('You have successfully made a donation!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.blue, // Changed background color to blue
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white), // Set text color to white
      ),
    );
  }
}

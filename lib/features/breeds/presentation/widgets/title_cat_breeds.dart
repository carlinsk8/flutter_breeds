import 'package:flutter/material.dart';

class TitleCatBreeds extends StatelessWidget {
  const TitleCatBreeds({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(('Cat Breeds').toUpperCase(),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        Image.asset('assets/images/logo_cat_n.png', width: 35),
      ],
    );
  }
}

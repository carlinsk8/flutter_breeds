// import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

import '../../../breeds/presentation/providers/breeds_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final providerBreeds = context.read<BreedsProvider>();
      await providerBreeds.getListBreed();
      await providerBreeds.getListImagesBreeds();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          context.go('/breeds');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(('Cat Breeds').toUpperCase(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(
                width: 200,
                height: 200,
                child: rive.RiveAnimation.asset(
                  'assets/rive/cat_animation.riv',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CircularProgressIndicator(color: Colors.black),
            ),
          ),
        ],
      ),
    );
}

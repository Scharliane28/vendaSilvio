import 'package:flutter/material.dart';
import 'telainicial.dart';

void main() {
  runApp(const meuaplicativo());
}

class meuaplicativo extends StatelessWidget {
  const meuaplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Vendas CEET',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const telainicial(),
    );
  }
}

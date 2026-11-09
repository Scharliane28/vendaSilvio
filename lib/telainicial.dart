import 'package:controlevendas/telaprodutos.dart';
import 'package:controlevendas/telavandas.dart';
import 'package:flutter/material.dart';
import 'telacliente.dart';

class telainicial extends StatelessWidget {
  const telainicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Vendas - CEET'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.store,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Cantina do CEET',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 230,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text('Clientes'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const telacliente(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 230,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.inventory),
                  label: const Text('Produtos'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const telaproduto(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 230,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.point_of_sale),
                  label: const Text('Vendas'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const telavendas(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

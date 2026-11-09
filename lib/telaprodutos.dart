import 'package:flutter/material.dart';
import 'produto.dart';
import 'dados.dart';

class telaproduto extends StatefulWidget {
  const telaproduto({super.key});

  @override
  State<telaproduto> createState() => _telaprodutoEstado();
}

class _telaprodutoEstado extends State<telaproduto> {
  final nome = TextEditingController();
  final unidade = TextEditingController();
  final valor = TextEditingController();
  final busca = TextEditingController();

  List<produto> get produtosFiltrados {
    final texto = busca.text.toLowerCase();

    return dados.produtos.where((p) {
      return p.nome.toLowerCase().contains(texto) ||
          p.unidade.toLowerCase().contains(texto) ||
          p.indice.toString().contains(texto);
    }).toList();
  }

  void limparCampos() {
    nome.clear();
    unidade.clear();
    valor.clear();
  }

  Future<void> abrirFormulario({produto? registro}) async {
    nome.text = registro?.nome ?? '';
    unidade.text = registro?.unidade ?? '';
    valor.text = registro?.valor.toStringAsFixed(2) ?? '';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            registro == null ? 'Cadastrar produto' : 'Editar produto',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nome,
                  decoration: const InputDecoration(
                    labelText: 'Nome do produto',
                  ),
                ),
                TextField(
                  controller: unidade,
                  decoration: const InputDecoration(
                    labelText: 'Unidade (unidade, kg, litro...)',
                  ),
                ),
                TextField(
                  controller: valor,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor (R\$)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final preco = double.tryParse(
                  valor.text.trim().replaceAll(',', '.'),
                );

                if (nome.text.trim().isEmpty ||
                    unidade.text.trim().isEmpty ||
                    preco == null ||
                    preco < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Informe nome, unidade e um valor válido.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  if (registro == null) {
                    dados.produtos.add(
                      produto(
                        indice: dados.proximoIndiceProduto++,
                        nome: nome.text.trim(),
                        unidade: unidade.text.trim(),
                        valor: preco,
                      ),
                    );
                  } else {
                    registro.nome = nome.text.trim();
                    registro.unidade = unidade.text.trim();
                    registro.valor = preco;
                  }
                });

                Navigator.pop(dialogContext);
                limparCampos();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> excluirProduto(produto registro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir ${registro.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        dados.produtos.remove(registro);
        dados.vendas.removeWhere(
          (v) => v.produtoVenda == registro,
        );
      });
    }
  }

  @override
  void dispose() {
    nome.dispose();
    unidade.dispose();
    valor.dispose();
    busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lista = produtosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: busca,
              decoration: const InputDecoration(
                labelText: 'Buscar produto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('Nenhum produto cadastrado.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final p = lista[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.inventory),
                          title: Text(p.nome),
                          subtitle: Text(
                            'Índice: ${p.indice}\n'
                            'Unidade: ${p.unidade}\n'
                            'Valor: R\$ ${p.valor.toStringAsFixed(2)}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcao) {
                              if (opcao == 'editar') {
                                abrirFormulario(registro: p);
                              } else {
                                excluirProduto(p);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'excluir',
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

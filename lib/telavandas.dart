import 'package:flutter/material.dart';
import 'dados.dart';
import 'cliente.dart';
import 'produto.dart';
import 'venda.dart';

class telavendas extends StatefulWidget {
  const telavendas({super.key});

  @override
  State<telavendas> createState() => _telavendasEstado();
}

class _telavendasEstado extends State<telavendas> {
  final quantidade = TextEditingController(text: '1');
  final vendedor = TextEditingController();
  final busca = TextEditingController();

  cliente? clienteSelecionado;
  produto? produtoSelecionado;
  DateTime dataSelecionada = DateTime.now();

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  List<venda> get vendasFiltradas {
    final texto = busca.text.toLowerCase();

    return dados.vendas.where((v) {
      return v.clienteVenda.nome.toLowerCase().contains(texto) ||
          v.produtoVenda.nome.toLowerCase().contains(texto) ||
          v.vendedor.toLowerCase().contains(texto) ||
          v.indice.toString().contains(texto);
    }).toList();
  }

  Future<void> abrirFormulario({venda? registro}) async {
    if (dados.clientes.isEmpty || dados.produtos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cadastre um cliente e um produto antes de registrar uma venda.',
          ),
        ),
      );
      return;
    }

    quantidade.text = registro?.quantidade.toString() ?? '1';
    vendedor.text = registro?.vendedor ?? '';
    clienteSelecionado = registro?.clienteVenda ?? dados.clientes.first;
    produtoSelecionado = registro?.produtoVenda ?? dados.produtos.first;
    dataSelecionada = registro?.data ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contexto, atualizarDialogo) {
            final qtd = int.tryParse(quantidade.text) ?? 0;
            final total = qtd > 0 && produtoSelecionado != null
                ? qtd * produtoSelecionado!.valor
                : 0.0;

            return AlertDialog(
              title: Text(
                registro == null ? 'Cadastrar venda' : 'Editar venda',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<cliente>(
                      value: clienteSelecionado,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                      ),
                      items: dados.clientes.map((c) {
                        return DropdownMenuItem<cliente>(
                          value: c,
                          child: Text(
                            c.nome,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (c) {
                        atualizarDialogo(() {
                          clienteSelecionado = c;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<produto>(
                      value: produtoSelecionado,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                      ),
                      items: dados.produtos.map((p) {
                        return DropdownMenuItem<produto>(
                          value: p,
                          child: Text(
                            '${p.nome} - R\$ ${p.valor.toStringAsFixed(2)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (p) {
                        atualizarDialogo(() {
                          produtoSelecionado = p;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantidade,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                      onChanged: (_) => atualizarDialogo(() {}),
                    ),
                    TextField(
                      controller: vendedor,
                      decoration: const InputDecoration(
                        labelText: 'Vendedor',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Data: ${formatarData(dataSelecionada)}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final data = await showDatePicker(
                              context: contexto,
                              initialDate: dataSelecionada,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (data != null) {
                              atualizarDialogo(() {
                                dataSelecionada = data;
                              });
                            }
                          },
                          child: const Text('Alterar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total: R\$ ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                    final qtdFinal = int.tryParse(quantidade.text.trim());

                    if (qtdFinal == null ||
                        qtdFinal <= 0 ||
                        vendedor.text.trim().isEmpty ||
                        clienteSelecionado == null ||
                        produtoSelecionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Informe a quantidade e o nome do vendedor.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (registro == null) {
                        dados.vendas.add(
                          venda(
                            indice: dados.proximoIndiceVenda++,
                            data: dataSelecionada,
                            quantidade: qtdFinal,
                            vendedor: vendedor.text.trim(),
                            clienteVenda: clienteSelecionado!,
                            produtoVenda: produtoSelecionado!,
                          ),
                        );
                      } else {
                        registro.data = dataSelecionada;
                        registro.quantidade = qtdFinal;
                        registro.vendedor = vendedor.text.trim();
                        registro.clienteVenda = clienteSelecionado!;
                        registro.produtoVenda = produtoSelecionado!;
                      }
                    });

                    Navigator.pop(dialogContext);
                    quantidade.text = '1';
                    vendedor.clear();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> excluirVenda(venda registro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir venda'),
        content: Text(
          'Deseja excluir a venda do produto ${registro.produtoVenda.nome}?',
        ),
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
        dados.vendas.remove(registro);
      });
    }
  }

  @override
  void dispose() {
    quantidade.dispose();
    vendedor.dispose();
    busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lista = vendasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirFormulario(),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Nova venda'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: busca,
              decoration: const InputDecoration(
                labelText: 'Buscar venda',
                hintText: 'Cliente, produto, vendedor ou índice',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('Nenhuma venda cadastrada.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final v = lista[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.point_of_sale),
                          title: Text(
                            'Venda ${v.indice} - ${v.produtoVenda.nome}',
                          ),
                          subtitle: Text(
                            'Data: ${formatarData(v.data)}\n'
                            'Cliente: ${v.clienteVenda.nome}\n'
                            'Quantidade: ${v.quantidade}\n'
                            'Vendedor: ${v.vendedor}\n'
                            'Total: R\$ ${v.total.toStringAsFixed(2)}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcao) {
                              if (opcao == 'editar') {
                                abrirFormulario(registro: v);
                              } else {
                                excluirVenda(v);
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

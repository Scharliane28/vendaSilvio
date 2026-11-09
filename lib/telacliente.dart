import 'package:flutter/material.dart';
import 'cliente.dart';
import 'dados.dart';

class telacliente extends StatefulWidget {
  const telacliente({super.key});

  @override
  State<telacliente> createState() => _telaclienteEstado();
}

class _telaclienteEstado extends State<telacliente> {
  final nome = TextEditingController();
  final cpf = TextEditingController();
  final telefone = TextEditingController();
  final apelido = TextEditingController();
  final turma = TextEditingController();
  final busca = TextEditingController();

  String turno = 'Matutino';

  List<cliente> get clientesFiltrados {
    final texto = busca.text.toLowerCase();

    return dados.clientes.where((c) {
      return c.nome.toLowerCase().contains(texto) ||
          c.cpf.toLowerCase().contains(texto) ||
          c.apelido.toLowerCase().contains(texto);
    }).toList();
  }

  void limparCampos() {
    nome.clear();
    cpf.clear();
    telefone.clear();
    apelido.clear();
    turma.clear();
    turno = 'Matutino';
  }

  Future<void> abrirFormulario({cliente? registro}) async {
    nome.text = registro?.nome ?? '';
    cpf.text = registro?.cpf ?? '';
    telefone.text = registro?.telefone ?? '';
    apelido.text = registro?.apelido ?? '';
    turma.text = registro?.turma ?? '';
    turno = registro?.turno ?? 'Matutino';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contexto, atualizarDialogo) {
            return AlertDialog(
              title: Text(
                registro == null ? 'Cadastrar cliente' : 'Editar cliente',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nome,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: cpf,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CPF'),
                    ),
                    TextField(
                      controller: telefone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Telefone'),
                    ),
                    TextField(
                      controller: apelido,
                      decoration: const InputDecoration(labelText: 'Apelido'),
                    ),
                    TextField(
                      controller: turma,
                      decoration: const InputDecoration(labelText: 'Turma'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: turno,
                      decoration: const InputDecoration(labelText: 'Turno'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Matutino',
                          child: Text('Matutino'),
                        ),
                        DropdownMenuItem(
                          value: 'Vespertino',
                          child: Text('Vespertino'),
                        ),
                        DropdownMenuItem(
                          value: 'Noturno',
                          child: Text('Noturno'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialogo(() {
                            turno = valor;
                          });
                        }
                      },
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
                    if (nome.text.trim().isEmpty ||
                        cpf.text.trim().isEmpty ||
                        telefone.text.trim().isEmpty ||
                        turma.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Preencha nome, CPF, telefone e turma.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (registro == null) {
                        dados.clientes.add(
                          cliente(
                            indice: dados.proximoIndiceCliente++,
                            nome: nome.text.trim(),
                            cpf: cpf.text.trim(),
                            telefone: telefone.text.trim(),
                            apelido: apelido.text.trim(),
                            turma: turma.text.trim(),
                            turno: turno,
                          ),
                        );
                      } else {
                        registro.nome = nome.text.trim();
                        registro.cpf = cpf.text.trim();
                        registro.telefone = telefone.text.trim();
                        registro.apelido = apelido.text.trim();
                        registro.turma = turma.text.trim();
                        registro.turno = turno;
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
      },
    );
  }

  Future<void> excluirCliente(cliente registro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir cliente'),
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
        dados.clientes.remove(registro);
        dados.vendas.removeWhere(
          (v) => v.clienteVenda == registro,
        );
      });
    }
  }

  @override
  void dispose() {
    nome.dispose();
    cpf.dispose();
    telefone.dispose();
    apelido.dispose();
    turma.dispose();
    busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lista = clientesFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirFormulario(),
        icon: const Icon(Icons.person_add),
        label: const Text('Cadastrar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: busca,
              decoration: const InputDecoration(
                labelText: 'Buscar cliente por nome, CPF ou apelido',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('Nenhum cliente cadastrado.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final c = lista[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(c.nome),
                          subtitle: Text(
                            'Índice: ${c.indice}\n'
                            'CPF: ${c.cpf}\n'
                            'Telefone: ${c.telefone}\n'
                            'Apelido: ${c.apelido}\n'
                            'Turma: ${c.turma} - ${c.turno}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcao) {
                              if (opcao == 'editar') {
                                abrirFormulario(registro: c);
                              } else {
                                excluirCliente(c);
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

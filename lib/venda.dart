import 'cliente.dart';
import 'produto.dart';

class venda {
  int indice;
  DateTime data;
  int quantidade;
  String vendedor;
  cliente clienteVenda;
  produto produtoVenda;

  venda({
    required this.indice,
    required this.data,
    required this.quantidade,
    required this.vendedor,
    required this.clienteVenda,
    required this.produtoVenda,
  });

  double get total {
    return quantidade * produtoVenda.valor;
  }
}

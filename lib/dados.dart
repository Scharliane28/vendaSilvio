import 'cliente.dart';
import 'produto.dart';
import 'venda.dart';

class dados {
  static final List<cliente> clientes = [];
  static final List<produto> produtos = [];
  static final List<venda> vendas = [];

  static int proximoIndiceCliente = 1;
  static int proximoIndiceProduto = 1;
  static int proximoIndiceVenda = 1;
}

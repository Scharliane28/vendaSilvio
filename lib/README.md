# Controle de Vendas — Cantina do CEET

## 1. Visão Geral do Projeto

O **Controle de Vendas — Cantina do CEET** é um aplicativo desenvolvido utilizando Flutter e Dart para organizar o gerenciamento de uma cantina escolar.

O objetivo do sistema é facilitar o cadastro e o controle de clientes, produtos e vendas. O aplicativo possui telas específicas para cada funcionalidade e permite realizar operações de cadastro, listagem, busca, edição e exclusão de registros.

Os dados são armazenados em listas durante a execução do aplicativo. Nesta versão, as informações não ficam salvas permanentemente após o encerramento do programa.

## 2. Mapeamento das Telas

O aplicativo possui quatro telas principais.

| Tela | Arquivo | Função |
|---|---|---|
| Tela Inicial | `telainicial.dart` | Apresenta o menu principal e os botões de acesso às demais telas. |
| Tela de Clientes | `telacliente.dart` | Permite cadastrar, visualizar, buscar, editar e excluir clientes. |
| Tela de Produtos | `telaproduto.dart` | Permite cadastrar, visualizar, buscar, editar e excluir produtos. |
| Tela de Vendas | `telavendas.dart` | Permite registrar, visualizar, buscar, editar e excluir vendas. |

### Tela Inicial

Apresenta o título do aplicativo, o nome da cantina e os botões para acessar as áreas de clientes, produtos e vendas.

### Tela de Clientes

Permite cadastrar clientes com nome, CPF, telefone, apelido, turma e turno. Também possui um campo de busca e opções para editar ou excluir os registros.

### Tela de Produtos

Permite cadastrar produtos com nome, unidade e valor. Os produtos cadastrados podem ser pesquisados, editados e excluídos.

### Tela de Vendas

Permite registrar uma venda selecionando um cliente e um produto cadastrados, informando a quantidade, o vendedor e a data. O sistema calcula automaticamente o valor total da venda.

## 3. Fluxo de Navegação e Transição de Dados

A navegação começa pela tela inicial, que funciona como menu principal do aplicativo.

Para abrir as demais telas, o projeto utiliza os recursos `Navigator.push()` e `MaterialPageRoute`, disponibilizados pelo Flutter.

O fluxo de navegação ocorre da seguinte maneira:

1. O usuário abre o aplicativo e visualiza a tela inicial.
2. Ao clicar em **Clientes**, acessa a tela de gerenciamento de clientes.
3. Ao clicar em **Produtos**, acessa a tela de gerenciamento de produtos.
4. Ao clicar em **Vendas**, acessa a tela de gerenciamento das vendas.

### Compartilhamento de dados

Os dados são compartilhados por meio da classe `dados`, que contém listas estáticas de clientes, produtos e vendas.

Dessa forma, as diferentes telas acessam as mesmas listas enquanto o aplicativo está em execução.

Na tela de vendas, os campos de seleção permitem escolher clientes e produtos cadastrados. Cada venda mantém referências ao cliente e ao produto selecionados.

Não são utilizados parâmetros de construtor para transferir os registros entre as telas principais. O compartilhamento ocorre por meio das listas da classe `dados`.

## 4. Estrutura de Código e Arquitetura

O projeto está organizado em arquivos Dart, separando os modelos de dados, o armazenamento temporário e as interfaces das telas.

### 4.1. Principais classes

| Classe | Arquivo | Responsabilidade |
|---|---|---|
| `meuaplicativo` | `main.dart` | Inicializa o aplicativo e configura o tema e a tela inicial. |
| `telainicial` | `telainicial.dart` | Apresenta o menu principal e realiza a navegação entre as telas. |
| `telacliente` | `telacliente.dart` | Implementa a interface e as operações de gerenciamento dos clientes. |
| `telaproduto` | `telaproduto.dart` | Implementa a interface e as operações de gerenciamento dos produtos. |
| `telavendas` | `telavendas.dart` | Implementa a interface e as operações de gerenciamento das vendas. |
| `cliente` | `cliente.dart` | Representa os dados de um cliente. |
| `produto` | `produto.dart` | Representa os dados de um produto. |
| `venda` | `venda.dart` | Representa uma venda e calcula seu valor total. |
| `dados` | `dados.dart` | Centraliza as listas compartilhadas e os contadores dos registros. |

### 4.2. Variáveis e atributos principais

**Classe `cliente`**

- `indice`: identifica o registro do cliente.
- `nome`: armazena o nome do cliente.
- `cpf`: armazena o CPF.
- `telefone`: armazena o telefone.
- `apelido`: armazena o apelido.
- `turma`: armazena a turma.
- `turno`: armazena o turno escolar.

**Classe `produto`**

- `indice`: identifica o registro do produto.
- `nome`: armazena o nome do produto.
- `unidade`: informa a unidade do produto, como unidade, quilograma ou litro.
- `valor`: armazena o valor unitário do produto.

**Classe `venda`**

- `indice`: identifica o registro da venda.
- `data`: armazena a data da venda.
- `quantidade`: informa a quantidade vendida.
- `vendedor`: armazena o nome do vendedor.
- `clienteVenda`: referencia o cliente relacionado à venda.
- `produtoVenda`: referencia o produto vendido.
- `total`: calcula o valor total multiplicando a quantidade pelo valor unitário do produto.

**Classe `dados`**

- `clientes`: lista de clientes cadastrados.
- `produtos`: lista de produtos cadastrados.
- `vendas`: lista de vendas registradas.
- `proximoIndiceCliente`: controla a numeração dos novos clientes.
- `proximoIndiceProduto`: controla a numeração dos novos produtos.
- `proximoIndiceVenda`: controla a numeração das novas vendas.

**Variáveis utilizadas nas telas**

Os objetos `TextEditingController` controlam os campos de texto dos formulários e das buscas. Também são utilizadas variáveis para armazenar o turno selecionado, o cliente e o produto escolhidos e a data da venda.

### 4.3. Principais métodos e funções

- `main()`: inicia a aplicação Flutter.
- `build()`: constrói os elementos visuais das telas.
- `abrirFormulario()`: abre o formulário de cadastro ou edição de registros.
- `limparCampos()`: limpa os campos do formulário de clientes ou produtos.
- `excluirCliente()`: solicita confirmação e exclui o cliente selecionado.
- `excluirProduto()`: solicita confirmação e exclui o produto selecionado.
- `excluirVenda()`: solicita confirmação e exclui a venda selecionada.
- `formatarData()`: apresenta a data no formato dia/mês/ano.
- `clientesFiltrados`: filtra clientes pelo nome, CPF ou apelido.
- `produtosFiltrados`: filtra produtos pelo nome, unidade ou índice.
- `vendasFiltradas`: filtra vendas pelo nome do cliente, nome do produto, vendedor ou índice.
- `dispose()`: libera os controladores de texto quando a tela é encerrada.
- `total`: calcula o valor da venda a partir da quantidade e do valor unitário do produto.

As operações de cadastro, edição e exclusão atualizam as listas compartilhadas e utilizam `setState()` para atualizar a interface.

## 5. Regras de Negócio e Validações

O aplicativo possui regras para garantir que os registros sejam preenchidos com as informações necessárias.

### 5.1. Clientes

- Nome, CPF, telefone e turma são obrigatórios.
- O apelido é opcional.
- O turno é selecionado entre Matutino, Vespertino e Noturno.
- A busca permite localizar clientes pelo nome, CPF ou apelido.
- A exclusão de um cliente também remove as vendas associadas a ele.

### 5.2. Produtos

- O nome do produto é obrigatório.
- A unidade deve ser informada.
- O valor deve ser numérico e não pode ser negativo.
- O sistema aceita vírgula ou ponto como separador decimal na entrada do valor.
- A busca permite localizar produtos pelo nome, unidade ou índice.
- A exclusão de um produto também remove as vendas associadas a ele.

### 5.3. Vendas

- É necessário cadastrar pelo menos um cliente e um produto antes de registrar uma venda.
- A quantidade deve ser um número inteiro maior que zero.
- O nome do vendedor é obrigatório.
- É necessário selecionar um cliente e um produto.
- A data pode ser escolhida por meio de um seletor de calendário.
- O total é calculado automaticamente pela multiplicação da quantidade pelo valor unitário do produto.
- A busca permite localizar vendas pelo cliente, produto, vendedor ou índice.

**Observação:** a versão atual não utiliza banco de dados. As listas armazenam os registros apenas enquanto o aplicativo está em execução.

## 6. Instruções para Execução

### 6.1. Requisitos

Para executar o projeto, são necessários:

- Flutter SDK instalado.
- Dart SDK compatível com o projeto, normalmente incluído no Flutter SDK.
- Visual Studio Code ou outra IDE compatível.
- Google Chrome para execução na Web ou um dispositivo/emulador configurado.
- Git instalado para clonar o repositório.

As versões utilizadas podem ser consultadas com os comandos:

```bash
flutter --version
dart --version
```

### 6.2. Clonar o repositório

No terminal, execute:

```bash
git clone URL_DO_REPOSITORIO
```

Substitua `URL_DO_REPOSITORIO` pelo endereço do repositório público do projeto no GitHub.

Depois, entre na pasta do projeto:

```bash
cd NOME_DA_PASTA
```

Substitua `NOME_DA_PASTA` pelo nome da pasta criada pelo Git.

### 6.3. Instalar as dependências

Execute o comando:

```bash
flutter pub get
```

Esse comando instala as dependências necessárias definidas no arquivo `pubspec.yaml`.

### 6.4. Executar o aplicativo

Para executar o projeto no Google Chrome:

```bash
flutter run -d chrome
```

Para executar em um dispositivo ou emulador disponível:

```bash
flutter run
```

### 6.5. Verificar o código

Para verificar possíveis problemas no código, execute:

```bash
flutter analyze
```

### 6.6. Arquivos necessários para compartilhar o projeto

O repositório do GitHub deve conter os arquivos necessários para abrir e executar a aplicação, incluindo:

- `lib/`: diretório com os arquivos Dart do aplicativo.
- `pubspec.yaml`: arquivo com as informações do projeto e suas dependências.
- `pubspec.lock`: arquivo com as versões resolvidas das dependências, quando gerado.
- `.gitignore`: arquivo que define quais arquivos e pastas não devem ser enviados ao repositório.
- `README.md`: documentação técnica do projeto.

Não é necessário enviar arquivos temporários gerados automaticamente pelo Flutter, como a pasta `build/`.

## 7. Considerações Finais

O desenvolvimento do Controle de Vendas — Cantina do CEET permitiu aplicar conceitos de programação em Dart e Flutter, criação de interfaces, organização de classes, navegação entre telas, manipulação de listas e operações de cadastro, consulta, edição e exclusão de dados.

O aplicativo reúne as principais informações de clientes, produtos e vendas em uma interface organizada. Futuramente, o sistema poderá ser ampliado com banco de dados para armazenamento permanente, relatórios de vendas e outras funcionalidades para melhorar o controle da cantina.

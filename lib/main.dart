import 'package:flutter/material.dart'; // importa os componentes Flutter

void main() {
  runApp(const MeuApp());
}

// classe principal do aplicativo
class MeuApp extends StatelessWidget {
  // como ela não precisa mudar de estado, foi usado StatelessWidget
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove a mensagem de DEBUG da tela
      title: 'Controle de Desperdício', // nome do app
      // tema padrão das telas
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF202020), // fundo preto
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red, // vermelho como cor principal
          brightness: Brightness.dark, // deixa no modo escuro
        ),
      ),

      home: const Login(), // primeira tela do app
    );
  }
}

// ================== LOGIN ==================

// tela de login
// por enquanto ela só serve para entrar no sistema, nao pede dados
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // fundo preto da tela de login

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31), // espaço dos lados

        child: Column(
          children: [
            const SizedBox(height: 35), // espaço acima da logo
            // logo da pizzaria salva na pasta assets
            Image.asset(
              'assets/logo.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain, // mantém a imagem no tamanho certo
            ),

            const SizedBox(height: 60), // espaco entre a logo e os capos
            // campo de e-mail
            const CampoLogin(hint: 'E-mail'),

            const SizedBox(height: 10),

            // campo de senha
            // senha: true faz o texto digitado ficar escondido
            const CampoLogin(hint: 'Senha', senha: true),

            const SizedBox(height: 40),

            // ocupa toda a largura do botão
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  // troca a tela de login pela Home
                  // pushReplacement impede voltar para o login pelo botão de voltar
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Home()),
                  );
                },

                // aparência do botão
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.zero, // tira bordas arredondadas do botao
                  ),
                ),

                child: const Text('ENTRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// campo reutilizado no e-mail e na senha
class CampoLogin extends StatelessWidget {
  final String hint; // texto que aparece dentro do campo
  final bool senha; // avisa se o campo deve esconder o texto

  const CampoLogin({
    super.key,
    required this.hint,
    this.senha = false, // o campo não é de senha
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: senha, // esconde a senha
      style: const TextStyle(color: Colors.white, fontSize: 12),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 12),

        // borda branca antes de clicar
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),

        // borda vermelha quando clica
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }
}

// ================== HOME ==================

// A Home precisa atualizar porque os dados e a tela podem mudar durante o uso do app
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // guarda qual tela está aberta

  int pagina = 0;

  // lista onde os desperdícios ficam salvos enquanto o app está aberto
  // cada item possui alimento, quantidade e motivo
  final List<Map<String, dynamic>> desperdicios = [];

  // controller do campo onde a pergunta é digitada
  final TextEditingController ctrlPergunta = TextEditingController();

  // soma os kg de todos os registros
  double get total {
    return desperdicios.fold(
      0.0,
      (soma, item) => soma + (item['quantidade'] as double),
    );
  }

  @override
  void dispose() {
    // libera o controller quando a tela deixa de existir
    ctrlPergunta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // mostra uma tela ou outra dependendo da do que escolher
      body: pagina == 0 ? telaDesperdicio() : telaIa(),

      // menu que fica na parte de baixo da tela
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pagina, // item selecionado no momento
        backgroundColor: const Color(0xFF292929),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,

        // recebe o índice do botão clicado
        onTap: (index) {
          setState(() {
            pagina = index; // troca a tela e atualiza a interface
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Desperdício',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'IA'),
        ],
      ),
    );
  }

  // ======================== DESPERDÍCIO ========================

  Widget telaDesperdicio() {
    return SafeArea(
      // SafeArea adiciona o limite da area para que nao atrapalhe os botoes do celular
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // alinha os textos a esquerda

          children: [
            const SizedBox(height: 20),

            // título da tela
            const Text(
              'Desperdício',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            // subtítulo
            const Text(
              'Controle da pizzaria',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // mostra o total calculado com casa decimal
            Text(
              'Total desperdiçado: ${total.toStringAsFixed(1)} kg',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 20),

            // botão para abrir a tela de cadastro dos alimentos disperdiçados
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: adicionarDesperdicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Adicionar desperdício'),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Registros',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            // Expanded faz a lista ocupar o espaço que sobrou na tela
            Expanded(
              child: desperdicios.isEmpty
                  // se não houver nenhum registro, mostra a mensagem de 'Nenhum desperdício registrado.'
                  ? const Center(
                      child: Text(
                        'Nenhum desperdício registrado.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  // se houver registros, cria a lista
                  : ListView.builder(
                      itemCount: desperdicios.length,

                      itemBuilder: (_, index) {
                        // pega o item de acordo com a posição da lista
                        final item = desperdicios[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          color: const Color(0xFF292929),

                          child: Row(
                            children: [
                              // deixa a parte de texto usar o espaço disponível
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // nome do alimento
                                    Text(
                                      item['alimento'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    // motivo do disperdicio no cadastro
                                    Text(
                                      'Motivo: ${item['motivo']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // quantidade de desperdício
                              Text(
                                '${item['quantidade']} kg',
                                style: const TextStyle(color: Colors.white),
                              ),

                              // botão de apagar o registro
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    desperdicios.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================ CADASTRO ================================

  Future<void> adicionarDesperdicio() async {
    final registro =
        await showDialog<({String alimento, double quantidade, String motivo})>(
          context: context,
          builder: (_) => const _DialogoAdicionarDesperdicio(),
        );

    if (!mounted || registro == null) {
      return;
    }

    setState(() {
      desperdicios.add({
        'alimento': registro.alimento,
        'quantidade': registro.quantidade,
        'motivo': registro.motivo,
      });
    });
  }

  // ========================= TELA DE IA =========================

  Widget telaIa() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            const Text(
              'Assistente',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Ajuda no controle do desperdício',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // espaço reservado para as respostas da IA futuramente
            const Expanded(
              child: Center(
                child: Text(
                  'A inteligência artificial será adicionada aqui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            // campo de escrita e botão de enviar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrlPergunta,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Digite uma pergunta...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF292929),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // botão que vai enviar a pergunta para a IA
                Container(
                  color: Colors.red,
                  child: IconButton(
                    onPressed: () {
                      // aqui será feita a integração com a IA
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogoAdicionarDesperdicio extends StatefulWidget {
  const _DialogoAdicionarDesperdicio();

  @override
  State<_DialogoAdicionarDesperdicio> createState() =>
      _DialogoAdicionarDesperdicioState();
}

class _DialogoAdicionarDesperdicioState
    extends State<_DialogoAdicionarDesperdicio> {
  final TextEditingController _ctrlAlimento = TextEditingController();
  final TextEditingController _ctrlQuantidade = TextEditingController();
  String _motivo = 'Sobra';

  @override
  void dispose() {
    _ctrlAlimento.dispose();
    _ctrlQuantidade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF292929),
      title: const Text('Adicionar', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ctrlAlimento,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Alimento'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _ctrlQuantidade,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Quantidade em kg'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _motivo,
            dropdownColor: const Color(0xFF292929),
            decoration: const InputDecoration(labelText: 'Motivo'),
            items:
                [
                  'Sobra',
                  'Vencimento',
                  'Erro de preparo',
                  'Excesso de produção',
                  'Outro',
                ].map((motivo) {
                  return DropdownMenuItem(value: motivo, child: Text(motivo));
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _motivo = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final alimento = _ctrlAlimento.text.trim();
            final quantidade = double.tryParse(
              _ctrlQuantidade.text.replaceAll(',', '.'),
            );
            if (alimento.isEmpty || quantidade == null) {
              return;
            }

            Navigator.pop(context, (
              alimento: alimento,
              quantidade: quantidade,
              motivo: _motivo,
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

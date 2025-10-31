// Importando a Biblioteca para trabalhar com números aleatórios //
import 'dart:math';
// Importando o Pacote principal do flutter  (widgets, design, etc)//
import 'package:flutter/material.dart';

// 1. Estrutura base do app //
// Função principal que inicia o app // 
void main() => runApp(
  const AplicativoJogodeDados()
);

// Raiz (base) d
//o App. Definir o tema e o fluxo inicial // 

class AplicativoJogodeDados extends StatelessWidget{
  const AplicativoJogodeDados({super.key});

  @override
  Widget build(BuildContext context){
    // Fazer um return do MaterialApp, que dá o visual ao projeto //
    return MaterialApp(
      title: 'Jogo de Dados', // Titulo Do Jogo //
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const TelaConfiguracaoJogadores(),
    );
  }
}

// 2. Tela de configurações de Jogadores //
// Primeira Tela do App. Coletar os nomes dos Jogadores // 

class TelaConfiguracaoJogadores extends StatefulWidget{
  const TelaConfiguracaoJogadores({super.key});

  @override
  // Cria o Objeto de Estado que vai gerenciar o formulário do Jogador //
  State<TelaConfiguracaoJogadores> createState() => _EstadoTelaConfiguracaoJogadores();
}

class _EstadoTelaConfiguracaoJogadores extends State<TelaConfiguracaoJogadores>{
  // Chave | variavel  Global -> usada para validar e identificara o widget //
  // FormState é o estado interno desse formulário, é a parte que sabe o que está digitado que consegue validar os campos // 
  final _chaveFormulario = GlobalKey<FormState>();   
  // final é uma palavra chave do dart para criar uma váriavel que só recebe valor uma vez // 
  // Controladores para pegar o texto digitado nos campos //
  final TextEditingController _controladorJogador1 = TextEditingController();
  final TextEditingController _controladorJogador2 = TextEditingController();

 @override
 Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuração dos Jogadores"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // Espaçamento Interno //
        child: Form(
          key: _chaveFormulario, // Associando a chave global ao formulário //
          child: Column(
            children: [
              // Campo de Texto Para o Jogador Numero 1 // 
              TextFormField(
                controller: _controladorJogador1,
                decoration: const InputDecoration(labelText: 'Nome Jogador 1'),
                validator: (valor) => valor!.isEmpty ? "Digite um nome" : null,
                // Condição ? valor_se_verdadeiro : valor_se_falso //
                // Se o campo estiver vazio, mostre o texto 'Digite um nome' // 
              ),

              const SizedBox(
                height: 16,
              ),

              TextFormField(
                controller: _controladorJogador2,
                decoration: const InputDecoration(labelText: 'Nome Jogador 2'),
                validator: (valor) => valor!.isEmpty ? "Digite um nome" : null,
              ),

              const Spacer(), // Ocupar o espaço vertical disponível, empurrando o botão p/ baixo //

              ElevatedButton(
                onPressed: () {
                  // Checar se o formulário está válido (se os campos foram preenchidos)
                  if (_chaveFormulario.currentState!.validate()){
                    // Navega para a proóxima Tela // 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Cria a Tela do Jogo, Passando os nomes digitados como Parâmetros // 
                        builder: (context) => TelaJogodeDados(
                          nomeJogador1: _controladorJogador1.text,
                          nomeJogador2: _controladorJogador2.text,
                        )
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  // Botao de largura total. // 
                ), 
                
                child: const Text("Iniciar Jogo"),

              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. Tela Principal Do Jogo // 

// Aqui vou receber os nomes como propriedades
class TelaJogodeDados extends StatefulWidget{
  // Variaveis finais que armazenam os nomes recebidos da tela anterior // 
  final String nomeJogador1;
  final String nomeJogador2;

  const TelaJogodeDados({
    super.key,
    // O required garante que esses valores devem ser passados //
    required this.nomeJogador1,
    required this.nomeJogador2,
  });

  @override
  // Usar a classe _EstadoTelaJogoDeDados para guardar e controlar o estado dela // 
  //_EstadoTelaJogoDeDados é o cérebro do robô que guarda o que está acontecendo. //
  // o createstate é o botão que coloca o cérebro //
  State<TelaJogodeDados> createState() => _EstadoTelaJogoDeDados();

}

class _EstadoTelaJogoDeDados extends State<TelaJogodeDados>{
  final Random _aleatorio = Random(); // Gerador de Números aleatórios // 
  // Lista dos 3 valores de cada Jogador. 
  List<int> _lancamentosJogador1 = [1,1,1];
  List<int> _lancamentosJogador2 = [1,1,1];
  String _mensagemResultado = ''; // Mensagem de resultado da rodada.//

  // Mapear as associações do número dado referente ao link
  final Map<int, String> imagensDados = {
    1: 'https://i.imgur.com/1xqPfjc.png&#39',
    2: 'https://i.imgur.com/5ClIegB.png&#39',
    3: 'https://i.imgur.com/hjqY13x.png&#39',
    4: 'https://i.imgur.com/CfJnQt0.png&#39',
    5: 'https://i.imgur.com/6oWpSbf.png&#39',
    6: 'https://i.imgur.com/drgfo7s.png&#39',
  };

  // Lógica da pontuação: Verifica combinações para aplicar os multiplicadores. //
  int _calcularPontuacao(List<int> lancamentos){
    // Reduce percorre toda a lista, somando tudo //
    final soma = lancamentos.reduce((a,b) => a + b);
    // [4,4,1] > 4 + 4 = 8 > 8 + 1 = 9 > soma = 9 //
    // [4,4,1] > [8,1] > [9] //
    final valoresUnicos = lancamentos.toSet().length;
    //toSet remove repetidos
    
    switch (valoresUnicos) {
      case 1: // exemplo: [5,5,5]. Três iguais = 3x a soma //
      return soma * 3;
      
      case 2: // Exemplo: [4,4,1]. Dois iguais = 2x a soma //
      return soma * 2;

      default: // Exemplo: [1,3,6]. Todos diferentes = soma pura. //
      return soma;
    }
  }
  // Função chamada pelo botão para lançar os dados // 
  void _lancarDados(){ // Uso do sublinhado ( _ ) significa que ela é privada
  //, ou seja só pode ser usado dentro da mesma classe //
    // comando essencial p/ forçar a atualização da tela //
    setState(() {
      _lancamentosJogador1 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);
      _lancamentosJogador2 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);

      final pontuacao1 = _calcularPontuacao(_lancamentosJogador1);
      final pontuacao2 = _calcularPontuacao(_lancamentosJogador2);

      if(pontuacao1 > pontuacao2){
        _mensagemResultado = '${widget.nomeJogador1} venceu! ($pontuacao1 x $pontuacao2)';
      } else if (pontuacao2 > pontuacao1) {
        _mensagemResultado = '${widget.nomeJogador2} venceu! ($pontuacao2 x $pontuacao1)';
      } else {
        _mensagemResultado = 'Empate! Joguem novamente.';
      }
    });
  }

  // Declara a função que devolve um widget: recebe nome, jogador, lancamentos
  // Os 3 valores do dado //
  Widget _construirColunaJogador(String nome, List<int> lancamentos){
    return Expanded( // Pega todo o espaço disponível dentro de uma row ou column //
      child: Column(
        children: [
          Text(
            nome,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center, // justify-content: center do css //
              children: lancamentos.map((valor) {
                // map transforma o número do dado em um widget de imagem //
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    imagensDados[valor]!, // Pega a url do mapa usando o 'valor' do dado
                    width: 50,
                    height: 50,
                    errorBuilder: (context, erro, stackTrace) =>
                    const Icon(
                      Icons.error,
                      size: 40,
                    ),
                  ),
                );
              }).toList(), // CONVERTE O RESULTADO DE VOLTA PARA UMA LISTA DE WIDGETS //
          )
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo de Dados'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              _construirColunaJogador(widget.nomeJogador1, _lancamentosJogador1),
              _construirColunaJogador(widget.nomeJogador2, _lancamentosJogador2),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _mensagemResultado,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(), // EMPURRA O BOTAO PARA A PARTE DE BAIXO DA TELA //
          ElevatedButton(
            onPressed: _lancarDados,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50)
            ),
            child: const Text('Jogar Dados'),
          ),
        ],        
      )
    );
  }
}
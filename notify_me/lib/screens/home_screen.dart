import 'package:flutter/material.dart';
import 'package:notify_me/screens/add_notification_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Opcional: para ícones de marcas reais

// 1. O Modelo (A "receita" do que compõe uma notificação)
class NotificationItem {
  final String appName;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.appName,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

class NotificationHomeScreen extends StatefulWidget {
  const NotificationHomeScreen({super.key});

  @override
  State<NotificationHomeScreen> createState() => _NotificationHomeScreenState();
}

class _NotificationHomeScreenState extends State<NotificationHomeScreen> {
  // Suas cores (mantive as do código anterior, ajuste se precisar)
  final Color spaceIndigo = const Color(0xFF000033);
  final Color grapeSoda = const Color(0xFFea2f59); // O seu laranja/salmão entraria aqui
  final Color amethystSmoke = const Color(0xFFA675A1);
  final Color grafite = const Color(0xFF466365);

  int _selectedIndex = 0;

  // 2. A Lista Dinâmica (Começa vazia)
  // Em vez de um número fixo, o app vai olhar para essa variável
  List<NotificationItem> myNotifications = [];

  // Função temporária para simular a criação (será substituída pela tela de criar depois)
  void _simulateAddNotification() {
    setState(() {
      // Adiciona um exemplo do Instagram
      myNotifications.add(
        NotificationItem(
          appName: 'Instagram',
          message: 'Alguém curtiu sua foto nova',
          time: '${DateTime.now().hour}:${DateTime.now().minute}',
          icon: Icons.camera_alt, // Ou FontAwesomeIcons.instagram se tiver o pacote
          iconColor: Colors.pinkAccent,
        ),
      );
      
      // Se quiser testar o Twitter/X, descomente abaixo e comente o de cima:
      /*
      myNotifications.add(
        NotificationItem(
          appName: 'Twitter',
          message: 'Elon Musk postou algo bizarro...',
          time: 'Agora',
          icon: Icons.alternate_email, 
          iconColor: Colors.blue,
        ),
      );
      */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spaceIndigo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Minhas Notificações', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: Icon(Icons.delete_outline, color: amethystSmoke), 
            onPressed: () {
              // Botãozinho extra pra limpar a lista e testar o estado vazio
              setState(() {
                myNotifications.clear();
              });
            }
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Seus filtros continuam aqui...
          const SizedBox(height: 20),
          
          // 3. A Lógica da Lista
          Expanded(
            child: myNotifications.isEmpty 
              ? _buildEmptyState() // Se estiver vazia, mostra desenho
              : ListView.builder(  // Se tiver itens, mostra a lista
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  // O segredo: itemCount é o tamanho da lista real!
                  itemCount: myNotifications.length, 
                  itemBuilder: (context, index) {
                    // Pega o item específico dessa linha
                    final item = myNotifications[index];
                    return _buildNotificationCard(item);
                  },
                ),
          ),
        ],
      ),
      
          floatingActionButton: FloatingActionButton(
            backgroundColor: grapeSoda,
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.black.withOpacity(0.55),
                  barrierDismissible: true,
                  transitionDuration: const Duration(milliseconds: 500),
                  reverseTransitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const AddNotificationScreen();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Animação: entra da direita para a esquerda
                    const begin = Offset(1.0, 0.0);   // começa fora da tela à direita
                    const end = Offset.zero;          // termina na posição final
                    const curve = Curves.easeOutCubic;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
    );
  }

  // Widget para quando não tem notificações
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: amethystSmoke.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'Tudo limpo por aqui!',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
          ),
          Text(
            'Toque no + para criar um lembrete',
            style: TextStyle(color: amethystSmoke, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Widget do Card atualizado para receber DADOS
  Widget _buildNotificationCard(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: grafite.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone Dinâmico
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: spaceIndigo,
                shape: BoxShape.circle,
                border: Border.all(color: item.iconColor.withOpacity(0.5)),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.appName, // Nome do App dinâmico
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(item.time,
                          style: TextStyle(color: amethystSmoke, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message, // Mensagem dinâmica
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
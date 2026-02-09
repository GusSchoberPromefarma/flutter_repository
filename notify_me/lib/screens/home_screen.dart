import 'package:flutter/material.dart';
import 'package:notify_me/screens/add_notification_screen.dart';
import '../models/notification_model.dart'; // <--- Import do Modelo
import '../database/db_helper.dart';       // <--- Import do Banco

class NotificationHomeScreen extends StatefulWidget {
  const NotificationHomeScreen({super.key});

  @override
  State<NotificationHomeScreen> createState() => _NotificationHomeScreenState();
}

class _NotificationHomeScreenState extends State<NotificationHomeScreen> {
  // Cores
  final Color spaceIndigo = const Color(0xFF000033);
  final Color grapeSoda = const Color(0xFFea2f59);
  final Color amethystSmoke = const Color(0xFFA675A1);
  final Color grafite = const Color(0xFF466365);

  int _selectedIndex = 0;

  // Função para carregar as notificações do Banco
  Future<List<NotificationModel>> _fetchNotifications() async {
    return await DBHelper().getNotifications();
  }

  // Função para deletar (já deixei pronta pro botão de lixeira)
  void _deleteNotification(int id) async {
    await DBHelper().deleteNotification(id);
    setState(() {}); // Recarrega a tela
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
          IconButton(
            icon: Icon(Icons.delete_outline, color: amethystSmoke), 
            onPressed: () {
              // TODO: Implementar limpeza total depois se quiser
            }
          ),
        ],
      ),
      
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // --- LISTA DO BANCO DE DADOS ---
          Expanded(
            child: FutureBuilder<List<NotificationModel>>(
              future: _fetchNotifications(), // <--- Chama o banco aqui
              builder: (context, snapshot) {
                // 1. Carregando...
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: grapeSoda));
                }
                
                // 2. Erro ou Vazio
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                // 3. Sucesso! Mostra a lista
                final notifications = snapshot.data!;
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: notifications.length, 
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return _buildNotificationCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: grapeSoda,
        onPressed: () async {
          // Navega e ESPERA (await) o resultado. Se voltar true, atualiza a tela.
          final result = await Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.black.withOpacity(0.55),
              barrierDismissible: true,
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) => const AddNotificationScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeOutCubic;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                return SlideTransition(position: animation.drive(tween), child: child);
              },
            ),
          );

          // Se a tela de cadastro retornou "true" (salvou algo), recarrega a lista
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget Vazio
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

  // Widget do Card (Adaptado para NotificationModel)
  Widget _buildNotificationCard(NotificationModel item) {
    return Dismissible( // <--- Bônus: Deslizar para apagar
      key: Key(item.id.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        if (item.id != null) _deleteNotification(item.id!);
      },
      child: Container(
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
              // Ícone (Tentando ser esperto: se for Insta/Twitter usa ícone específico, senão genérico)
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: spaceIndigo,
                  shape: BoxShape.circle,
                  border: Border.all(color: amethystSmoke.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.notifications_active, // Depois podemos melhorar para mostrar o ícone do app real
                  color: amethystSmoke,
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
                          item.appName, 
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${item.hour.toString().padLeft(2, '0')}:${item.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: amethystSmoke, fontSize: 12)
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.message,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
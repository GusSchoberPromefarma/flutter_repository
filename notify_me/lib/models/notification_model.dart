class NotificationModel {
  final int? id;            // ID único do banco
  final String appName;     // Nome bonito (Ex: Instagram)
  final String packageName; // Nome técnico (Ex: com.instagram.android) - IMPORTANTE p/ abrir o app depois
  final String message;     // O texto do lembrete
  final int hour;           // Hora (0-23)
  final int minute;         // Minuto (0-59)

  NotificationModel({
    this.id,
    required this.appName,
    required this.packageName,
    required this.message,
    required this.hour,
    required this.minute,
  });

  // Transforma nossos dados em um Mapa (JSON) para o banco entender
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appName': appName,
      'packageName': packageName,
      'message': message,
      'hour': hour,
      'minute': minute,
    };
  }

  // Transforma o Mapa do banco de volta em dados para o App usar
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      appName: map['appName'],
      packageName: map['packageName'],
      message: map['message'],
      hour: map['hour'],
      minute: map['minute'],
    );
  }
}
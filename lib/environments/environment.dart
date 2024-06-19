import 'package:origination/models/utils/server_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Environment {

  //Default Dev server
  static String baseUrl = 'http://13.127.65.162/server/';
  static ServerType currentServerType = ServerType.Local;

  static void setServerType(ServerType type) async {
    
    switch (type) {
      case ServerType.Local:
        // baseUrl = 'http://172.20.10.3:8080/';     // Local
        baseUrl = 'http://10.0.2.2:8080/';       // Laptop hotspot
        // baseUrl = 'http://192.168.2.120:8080/';     // Local Anusha
        break;
      case ServerType.LocalStatic:
        baseUrl = 'http://192.168.2.170:8080/';   // Local static
        break;
      case ServerType.Ft7Dev:
        baseUrl = 'http://13.127.65.162/ft7-sandbox/'; // Ft7Dev
        break;
      case ServerType.Development:
        baseUrl = 'http://13.127.65.162/server/'; // Dev
        break;
      case ServerType.Staging:
        baseUrl = 'http://13.127.140.32/server/'; // Staging
        break;
    }
    currentServerType = type;
    await saveServerType(type);
  }

  static Future<void> saveServerType(ServerType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('serverType', type.index);
  }

  static ServerType getServerType() {
    return currentServerType;
  }

  static Future<void> loadServerType() async {
    final prefs = await SharedPreferences.getInstance();
    final serverIndex = prefs.getInt('serverType');
    if (serverIndex != null) {
      currentServerType = ServerType.values[serverIndex];
      setServerType(currentServerType); // Update baseUrl
    } else {
      currentServerType = ServerType.Development; // Default to development server type
      await saveServerType(ServerType.Development); // Store default value in local storage
    }
  }
}
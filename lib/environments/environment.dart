import 'package:origination/models/utils/server_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Environment {

  //Default Dev server
  static String baseUrl = 'http://13.127.65.162/server/';
  static ServerType currentServerType = ServerType.development;

  static void setServerType(ServerType type) async {
    
    switch (type) {
      case ServerType.local:
        baseUrl = 'http://172.20.10.3:8080/';     // Local
        break;
      case ServerType.localStatic:
        baseUrl = 'http://192.168.2.254:8080/';   // Local static
        break;
      case ServerType.development:
        baseUrl = 'http://13.127.65.162/server/'; // Dev
        break;
      case ServerType.staging:
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
      currentServerType = ServerType.development; // Default to development server type
      await saveServerType(ServerType.development); // Store default value in local storage
    }
  }
}
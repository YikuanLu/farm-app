import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage {
  /*
   *存储数据
   */
  static Future setItem(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  /*
   * 读取数据
   */
  static Future getItem(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  /*
   * 删除数据
   */
  static Future removeItem(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
    print('删除$key' + '成功');
  }
}

import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/user_model.dart';


class DBUser {
  final DBService _dbService;

  DBUser(this._dbService);

  Future<bool> userExists(String login, String email) async {
    var sql = 'SELECT * FROM User WHERE user_login = ${HHVar.c} OR user_email = ${HHVar.c}';
    var result = await _dbService.query(sql, [login, email]);
    return result.isNotEmpty;
  }

  Future<void> insertUser(UserModel user) async {
    bool exists = await userExists(user.login, user.email);
    if (exists) {
      throw Exception('Login or email already exists');
    }

    var sql = '''
      INSERT INTO User (
        user_login, 
        user_email, 
        user_password, 
        user_name, 
        user_cpf, 
        user_rg, 
        user_address, 
        user_city, 
        user_uf) 
        VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c})
        ''';

    var values = [
      user.login,
      user.email,
      user.password,
      user.name,
      user.cpf,
      user.rg,
      user.address,
      user.city,
      user.uf,
    ];

    await _dbService.query(sql, values);
  }

  Future<UserModel?> verifyUser(String login, String password) async {
    var sql = 'SELECT * FROM User WHERE user_login = ${HHVar.c} AND user_password = ${HHVar.c}';
    print("DBUSER:   SQL: $sql");
    print("DBUSER:   ${[login, password]}");
    var result = await _dbService.query(sql, [login, password]);

    print("RESULT DBUSER:");
    print(result);

    if (result.isNotEmpty) {
      var row = result.first;
      print(row['user_id']);
      return UserModel(
        //userId: int.parse(row['user_id']),
        userId: row['user_id'] as int,
        login: row['user_login'] as String? ?? '',
        email: row['user_email'] as String? ?? '',
        password: row['user_password'] as String? ?? '',
        name: row['user_name'] as String? ?? '',
        address: row['user_address'] as String? ?? '',
        city: row['user_city'] as String? ?? '',
        uf: row['user_uf'] as String? ?? '',
        cpf: row['user_cpf'] as String? ?? '',
        rg: row['user_rg'] as String? ?? '',
        phone: row['user_phone'] as String? ?? '',
      );
    }

    return null;
  }

  Future<void> updateUser(UserModel user) async {
    var sql = '''
    UPDATE User SET 
      user_email = ${HHVar.c}, 
      user_name = ${HHVar.c}, 
      user_cpf = ${HHVar.c},
      user_rg = ${HHVar.c}, 
      user_address = ${HHVar.c}, 
      user_city = ${HHVar.c}, 
      user_uf = ${HHVar.c},
      user_phone = ${HHVar.c}
    WHERE user_login = ${HHVar.c}
    ''';

    var values = [
      user.email,
      user.name,
      user.cpf,
      user.rg,
      user.address,
      user.city,
      user.uf,
      user.phone,
      user.login,
    ];

    await _dbService.query(sql, values);
  }

  Future<void> updateUser2(UserModel oldUser, UserModel newUser) async {
    Map<String, dynamic> oldUserMap = oldUser.toMap();
    Map<String, dynamic> newUserMap = newUser.toMap();
    Map<String, dynamic> updatedFields = {};
    newUserMap.forEach((key, newValue) {
      if (oldUserMap[key] != newValue) {
        updatedFields[key] = newValue;
      }
    });

    List<String> setClauses = [];
    List<dynamic> values = [];
    updatedFields.forEach((key, value) {
      setClauses.add("$key = ${HHVar.c}");
      values.add(value);
    });

    values.add(newUser.login);

    String sql = "UPDATE User SET ${setClauses.join(", ")} WHERE user_login = ${HHVar.c}";

    await _dbService.query(sql, values);
  }

  Future<void> deleteLastUser() async {
    var sql = 'SELECT MAX(user_id) AS last_id FROM User';
    var result = await _dbService.query(sql);

    if (result.isNotEmpty) {
      var lastId = result.first['last_id'];
      sql = 'DELETE FROM User WHERE user_id = ${HHVar.c}';
      await _dbService.query(sql, [lastId]);
    }
  }

  /*Future<void> deleteAllUsers() async {
    var sql = 'SELECT MAX(user_id) AS last_id FROM User';
    var result = await _dbService.query(sql);

    if (result.isNotEmpty) {
      sql = 'DELETE FROM User';
      await _dbService.query(sql);
    }
  }*/
}

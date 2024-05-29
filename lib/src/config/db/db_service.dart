import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

class DBService {
    //final String apiGatewayUrl = 'https://15a49x9kdi.execute-api.sa-east-1.amazonaws.com/default/DBHandler'; //LAMBDA - AMAZON RDS
    final String apiGatewayUrl = 'https://www.hiperhyped.com.br/db_handler.php';   // PHP - LOCALWEB

    Future<List<dynamic>> query(String sql, [List<dynamic>? values]) async {
    try {
      // Construir o corpo da requisição
      var body = json.encode({
        'sql': sql,
        'values': values,
      });

      // Fazer a requisição POST
      final response = await http.post(
        Uri.parse(apiGatewayUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Verificar o status da resposta
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        // Se a resposta for uma lista, retorne-a
        if (responseBody is List) {
          return responseBody;
        }
        // Se a resposta for um mapa com a mensagem 'Success', retorne uma lista vazia
        else if (responseBody is Map && responseBody['message'] == 'Success') {
          return [];
        }
        // Caso contrário, lance uma exceção
        else {
          throw Exception('Resposta inesperada: $responseBody');
        }
      } else {
        throw Exception('Falha na consulta ao banco de dados, status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      // Lidar com exceção específica de cliente HTTP
      print('Erro de rede: ${e.toString()}');
      print('Erro type: ${e.runtimeType}');
      print('Uma falha de rede ocorreu.');
      throw Exception('Erro de rede ao fazer a requisição HTTP.');
    } on FormatException catch (e) {
      // Lidar com FormatException
      print('Erro de formato de resposta: ${e.toString()}');
      print('O formato da resposta não era o esperado.');
      throw Exception('Formato de resposta inesperado.');
    } catch (e) {
      // Lidar com outras exceções não tratadas
      print('Erro inesperado: ${e.toString()}');
      print('Tipo de erro: ${e.runtimeType}');
      print('Um erro inesperado ocorreu.');
      throw Exception('Erro inesperado ao fazer a requisição HTTP.');
    }
  }


    Future<List<dynamic>> rawQuery(String sql) {
        return query(sql);
    }

    
    // Novo método para executar chamadas CALL sem esperar resposta
    Future<void> call(String procedureName) async {
      String sql = 'CALL $procedureName();';
      await query(sql, []);
    }
}

//// VERSAO COM CLOSE CONNEXION - LINK DIRETO COM DB - NÂO FUNCIONA PAR BROWSER - "HHVAR.c ='?'"
/*class DBService {

  //HHDBv1
  final String host = 'hhdbv1.mysql.dbaas.com.br';
  final int port = 3306;
  final String user = 'hhdbv1';
  final String password = 'HHDBv1!';
  final String db = 'hhdbv1';

  //HHDBv0
  /*
  final String host = 'hhdbv0.mysql.dbaas.com.br';
  final int port = 3306;
  final String user = 'hhdbv0';
  final String password = 'HHDBv0!';
  final String db = 'hhdbv0';
  */

  MySqlConnection? _connection;

  Future<void> open() async {
    final settings = ConnectionSettings(
      host: host, 
      port: port, 
      user: user, 
      password: password, 
      db: db,
    );

    _connection = await MySqlConnection.connect(settings);
  }

  Future<void> close() async {
    await _connection?.close();
  }

  MySqlConnection? get connection => _connection;

  Future<Results> query(String sql, [List<dynamic>? values]) async {
    try {
      await open();
      return await _connection!.query(sql, values);
    } finally {
      await close();
    }
  }

  Future<Results> rawQuery(String sql) async {
    try {
      await open();
      return await _connection!.query(sql);
    } finally {
      await close();
    }
  }
}*/

//Class DBService para GATEWAY    "HHVAR.c ='%s'"

    /*
    print('Sending request to this URL: $apiGatewayUrl');
    print('With these headers: ${json.encode({'Content-Type': 'application/json'})}');
    print('Sending this body to the server: $body');
    */

    /*
    print("HEADERS");
    print(response.headers);
    print("REQUEST");
    print(response.request);
    print("STATUS CODE");
    print(response.statusCode);
    print("RESPONSE:");
    print(json.decode(response.body));
    */

/*
class DBService {
  
  //HHV1
  /*
  final String host = 'hhv1.clnzsht6azj4.sa-east-1.rds.amazonaws.com';
  final int port = 3306;
  final String user = 'admin';
  final String password = 'admin2023';
  final String db = 'HHV1';
  */

  //HHV2
  /*final String host = 'hhv2.cluster-clnzsht6azj4.sa-east-1.rds.amazonaws.com';
  final int port = 3306;
  final String user = 'admin';
  final String password = 'admin2023';
  final String db = 'HHV1';
  */

  //HHDBv0
  final String host = 'hhdbv0.mysql.dbaas.com.br';
  final int port = 3306;
  final String user = 'hhdbv0';
  final String password = 'HHDBv0!';
  final String db = 'hhdbv0';
  
  MySqlConnection? _connection;

  Future<void> open() async {
    final settings = ConnectionSettings(
      host: host, 
      port: port, 
      user: user, 
      password: password, 
      db: db,
    );

    _connection = await MySqlConnection.connect(settings);
  }

  Future<void> close() async {
    await _connection?.close();
  }

  MySqlConnection? get connection => _connection;

  Future<Results> query(String sql, [List<dynamic>? values]) async {
    if (_connection == null) {
      await open();
    }
    //print(sql);
    //print(values);
    return _connection!.query(sql, values);
  }

  Future<Results> rawQuery(String sql) async {
    if (_connection == null) {
      await open();
    }
    print(sql);
    return _connection!.query(sql);
  }
}*/

/*class DBService {
  // Define os parâmetros de conexão
  final String host = 'hhv1.clnzsht6azj4.sa-east-1.rds.amazonaws.com';
  final int port = 3306;
  final String user = 'admin';
  final String password = 'admin2023';
  final String db = 'HHV1';

  MySqlConnection? _connection;

  // Método para conectar ao banco de dados
  Future<void> open() async {
    final settings = ConnectionSettings(
      host: host, 
      port: port, 
      user: user, 
      password: password, 
      db: db,
    );

    _connection = await MySqlConnection.connect(settings);
  }

  // Método para fechar a conexão
  Future<void> close() async {
    await _connection?.close();
  }

  // Método para obter a conexão
  MySqlConnection? get connection => _connection;

  // Método para executar uma consulta
  /*Future<Results> query(String sql) async {
    if (_connection == null) {
      await open();
    }
    
    return _connection!.query(sql);
  }*/

  Future<Results> query(String sql, [List<dynamic>? values]) async {
    if (_connection == null) {
      await open();
    }
    
    return _connection!.query(sql, values);
  }

/*
Future<void> insertUser(UserModel user) async {
  // Check if the connection is established
  if (_connection == null) {
    print("CONNECTION IS OFF");
    print(_connection);
    await open();
  }

  print("CONNECTION IS ON");
  print(_connection);
  // Convert the user to a map
  var userMap = user.toMap();

  // Create SQL query
  var sql = 'INSERT INTO User (user_login, user_email, user_password, user_name, user_cpf, user_rg, user_address, user_city, user_uf) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';

  // Convert the map values to a list
  var values = userMap.values.toList();
  print("VALUES : $values");
  print("SQL: $sql");

  // Execute the SQL query
  await _connection!.query(sql, values);
  }
*/
  
  ///////////////////
  /// USER EXISTS?
  Future<bool> userExists(String login, String email) async {
    if (_connection == null) {
      await open();
    }
    var sql = 'SELECT * FROM User WHERE user_login = ? OR user_email = ?';
    var result = await _connection!.query(sql, [login, email]);
    return result.isNotEmpty;
  }


  /////////////////
  /// INSERT USER
  Future<void> insertUser(UserModel user) async {
    if (_connection == null) {
      await open();
    }

    bool exists = await userExists(user.login, user.email);
    if (exists) {
      throw Exception('Login or email already exists');
    }

    if (!Utils.isEmail(user.email)) {
      throw Exception('Email format is incorrect');
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
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
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

    print("VALUES2 : $values");
    print("SQL: $sql");

    // Execute the query
    await _connection!.query(sql, values);
    // Print success message
    print("Query executed successfully. User ${user.login} has been inserted into the database.");
  }


  ///////////////
  /// VERIFY USER
  Future<UserModel?> verifyUser(String login, String password) async {
    if (_connection == null) {
      await open();
    }

    var sql = 'SELECT * FROM User WHERE user_login = ? AND user_password = ?';
    var result = await _connection!.query(sql, [login, password]);

    if (result.isNotEmpty) {
      // Usuário encontrado
      var row = result.first;
      print("RESULTADO: $row");
      return UserModel(
        userId: row['user_id'],
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

    return null;  // Retorne null se o usuário não for encontrado
  }


  ///////////////////
  /////// UPDATE USER
  Future<void> updateUser(UserModel user) async {
  if (_connection == null) {
    await open();
  }

  var sql = '''
    UPDATE User SET 
      user_email = ?, 
      user_name = ?, 
      user_cpf = ?, 
      user_rg = ?, 
      user_address = ?, 
      user_city = ?, 
      user_uf = ?,
      user_phone = ?
    WHERE user_login = ?
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

  await _connection!.query(sql, values);
  print("Query executed successfully. User ${user.login} has been updated in the database.");
  
  }


  //////////////////
  /// UPDATE USER 2
  Future<void> updateUser2(UserModel oldUser, UserModel newUser) async {
  if (_connection == null) {
    await open();
  }

  // Determina quais campos foram alterados.
  Map<String, dynamic> oldUserMap = oldUser.toMap();
  Map<String, dynamic> newUserMap = newUser.toMap();
  Map<String, dynamic> updatedFields = {};
  newUserMap.forEach((key, newValue) {
    if (oldUserMap[key] != newValue) {
      updatedFields[key] = newValue;
    }
  });

  // Gera a consulta SQL dinamicamente com base nos campos alterados.
  List<String> setClauses = [];
  List<dynamic> values = [];
  updatedFields.forEach((key, value) {
    setClauses.add("$key = ?");
    values.add(value);
  });

  // Adiciona o user_id no final dos valores.
  values.add(newUser.login);

  String sql = "UPDATE User SET ${setClauses.join(", ")} WHERE user_login = ?";

  await _connection!.query(sql, values);
  print(sql);
  print("Query executed successfully. User ${newUser.login} has been updated in the database.");
}


  Future<void> deleteLastUser() async {
  // Check if the connection is established
    if (_connection == null) {
      await open();
    }
    var sql = 'SELECT MAX(user_id) AS last_id FROM User';
    var result = await _connection!.query(sql);

    if (result.isNotEmpty) {
      var lastId = result.first['last_id'];
      sql = 'DELETE FROM User WHERE user_id = ?';
      await _connection!.query(sql, [lastId]);
    }
}

Future<void> deleteAllUsers() async {
  // Check if the connection is established
    if (_connection == null) {
      await open();
    }
    var sql = 'SELECT MAX(user_id) AS last_id FROM User';
    var result = await _connection!.query(sql);

    if (result.isNotEmpty) {
      sql = 'DELETE FROM User';
      await _connection!.query(sql);
    }
}


}
*/

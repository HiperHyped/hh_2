// database_creator.dart
//NOT USED
import 'package:mysql1/mysql1.dart';

class DBCreator {
  static Future<MySqlConnection> connectToDatabase() async {
    return MySqlConnection.connect(ConnectionSettings(
      host: 'hhv1.clnzsht6azj4.sa-east-1.rds.amazonaws.com', 
      port: 3306,
      user: 'admin', 
      password: 'admin2023', 
      db: 'HHV1',
    ));
  }

  static Future<void> createUserTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS User (
        user_id INT PRIMARY KEY, 
        user_name VARCHAR(50), 
        user_password VARCHAR(50),
        user_email VARCHAR(50), 
        user_type VARCHAR(50)
      )
    ''');
  }

  static Future<void> createUserInfoTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS User_Info (
        user_id INT, 
        user_address VARCHAR(50), 
        user_phone VARCHAR(15),
        FOREIGN KEY (user_id) REFERENCES User(user_id)
      )
    ''');
  }

  static Future<void> createUserPayTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS User_Pay (
        user_id INT,
        user_payment_type VARCHAR(50),
        user_card VARCHAR(50),
        FOREIGN KEY (user_id) REFERENCES User(user_id)
      )
    ''');
  }

  static Future<void> createUserHistoryTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS User_History (
        user_id INT,
        order_id INT,
        uh_date DATE,
        FOREIGN KEY (user_id) REFERENCES User(user_id),
        FOREIGN KEY (order_id) REFERENCES Order(order_id)
      )
    ''');
  }

  static Future<void> createOrderTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS Order (
        order_id INT PRIMARY KEY,
        order_status VARCHAR(50),
        order_date DATE
      )
    ''');
  }

  static Future<void> createOrderListTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS Order_List (
        order_id INT,
        product_id INT,
        prod_quantity INT,
        prod_price DECIMAL(10,2),
        FOREIGN KEY (order_id) REFERENCES Order(order_id),
        FOREIGN KEY (product_id) REFERENCES Product(product_id)
      )
    ''');
  }

  static Future<void> createProductTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS Product (
        product_id INT PRIMARY KEY,
        prod_ean VARCHAR(50),
        prod_name VARCHAR(50),
        prod_brand VARCHAR(50),
        prod_image VARCHAR(255),
        cat2 VARCHAR(50),
        word1 VARCHAR(50),
        word2 VARCHAR(50),
        word3 VARCHAR(50),
        word4 VARCHAR(50)
      )
    ''');
  }

  static Future<void> createCategoryTable(MySqlConnection conn) async {
    await conn.query('''
      CREATE TABLE IF NOT EXISTS Category (
        cat_id INT PRIMARY KEY,
        cat_name VARCHAR(50),
        cat_level INT,
        cat_emoji VARCHAR(10)
      )
    ''');
  }

  static Future<void> initializeDatabase() async {
    var conn = await connectToDatabase();
    await createUserTable(conn);
    await createUserInfoTable(conn);
    await createUserPayTable(conn);
    await createUserHistoryTable(conn);
    await createOrderTable(conn);
    await createOrderListTable(conn);
    await createProductTable(conn);
    await createCategoryTable(conn);
  }
}
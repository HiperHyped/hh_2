class UserModel {
  int userId;
  String login;
  String email;
  String password;
  String name;
  String cpf;
  String rg;
  String address;
  String city;
  String uf;
  String phone;


  UserModel({
    this.userId=0,
    required this.password, 
    required this.login, 
    this.name ="",
    this.email="",
    this.cpf="",
    this.rg="",
    this.address="",
    this.city="",
    this.uf="",
    this.phone="",
    });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_login': login,
      'user_email': email,
      'user_name': name,
      'user_password': password,
      'user_cpf': cpf,
      'user_rg': rg,
      'user_address': address,
      'user_city': city,
      'user_uf': uf,

    };
  }
}

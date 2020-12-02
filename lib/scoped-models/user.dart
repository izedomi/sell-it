//import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';


class UsersModel{
  User _authenticatedUser;

  void login(String email, String password){
      _authenticatedUser = User(
        id: "jklkdsadf",
        email: email,
        password: password
      );
  }

  User get authUser{
     return _authenticatedUser;
   }
}
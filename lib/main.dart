import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

import './scoped-models/main.dart';


main() => runApp(MyApp());


class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
 
  @override
  Widget build(BuildContext context) {
    MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple
          ),
        home: AuthPage(),
        routes: {
          'products' :  (BuildContext context)=> ProductsPage(model),
          'admin' : (BuildContext context) => ProductAdminPage(model)
        },
        onGenerateRoute: (RouteSettings settings){
          final List<String> routePaths = settings.name.split('/');
          if(routePaths[0] != ""){
            return null;
          }
          if(routePaths[1] == "product"){
            final int index = int.parse(routePaths[2]);
            return MaterialPageRoute<bool>(
              builder:(BuildContext context) => ProductPage(index)
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings){
          return MaterialPageRoute(builder: (BuildContext context)=> ProductsPage(model));
        },
      )
    );
    
  }

}

import 'package:flutter/material.dart';
import 'package:sell_it/scoped-models/main.dart';

//import './products.dart';
import './product_list.dart';
import './product_edit.dart';

class ProductAdminPage extends StatelessWidget {

  final MainModel model;

  ProductAdminPage(this.model);


  Widget _buildDrawerNavigation(BuildContext context){
      return Drawer(
        child: Column(
          children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text("Manage Product")
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("All Products"),
                onTap: (){
                  Navigator.pushReplacementNamed(context, 'products');
                },
              )
          ],
        )  ,
      );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:Scaffold(
      drawer: _buildDrawerNavigation(context),
      appBar: AppBar(
        title: Text("Manage Product"),
        bottom: TabBar(
          tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: "Create Product",
              ),
              Tab(
                icon: Icon(Icons.list),
                text: "Manage Product"
              )
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          ProductEdit(),
          ProductList(model)
        ],
      )
    )
    );
  }
}
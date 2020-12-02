import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';
import 'package:sell_it/scoped-models/main.dart';
//import 'package:sell_it/pages/product_admin.dart';

import '../widgets/products/products.dart';



class ProductsPage extends StatefulWidget {

  final MainModel model;

  ProductsPage(this.model);
  
  @override
  State<StatefulWidget> createState() {
  
    return _ProductsPageState() ;
  }

}


class _ProductsPageState extends State<ProductsPage>{

  @override
  initState(){
     widget.model.fetchProduct();
     super.initState();
  }


  Widget _buildDrawerNavigation(BuildContext context){
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text("Choose")
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Products"),
          onTap: (){
            Navigator.pushReplacementNamed(context, 'admin');
          },
        )
      ],),
    );
  }

  Widget _buildProductList(BuildContext context){
      Widget content = Center(child: Text('No products found'));

     return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
        
        if(model.isLoading){
          content = Center(child: CircularProgressIndicator());
        }
        else if(model.displayedProducts.length > 0 && !model.isLoading){
          content = Products();
        }
        else if(model.displayedProducts.length < 1 && !model.isLoading){
          content = Center(child: Text('No products found'));
        }

        return RefreshIndicator(onRefresh: model.fetchProduct, child: content);
      });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _buildDrawerNavigation(context),
        appBar: AppBar(
          title: Text('Sell it'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
              return IconButton(
                icon: Icon(model.displayFavouriteOnly ? Icons.favorite : Icons.favorite_border),
                onPressed: (){
                   model.toggleDisplayMode();
                },
              );
            })           
          ],

        ),
        body: _buildProductList(context)
      );
  }
}
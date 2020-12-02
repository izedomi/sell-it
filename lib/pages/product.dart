import 'dart:async';
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "../scoped-models/main.dart";
import "../models/product.dart";
import '../widgets/ui_elements/title_default.dart';


class ProductPage extends StatelessWidget {

  final int index;

  ProductPage(this.index);


  /*
  _showAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Are you sure?"),
        content: Text("Action cannot be undone"),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"), 
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text("CONTINUE"),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context, true);
            } 
          )
        ],
      );
    });
  }
  */

  Widget _buildProductDetails(Product product){
      return Column(
        children: <Widget>[
          Image.network(product.image),
          Container(
            padding: EdgeInsets.all(7.0),
            child:TitleDefault(product.title),
          ),
          Container(
            padding: EdgeInsets.all(3.0),
            child: Text(
              "Woji, Port Harcourt" + " | " + "\$"+product.price.toString(),
              style: TextStyle(
                color: Colors.grey, 
                fontFamily: 'Oswald'
              )
            )
          ),
          Container(
            child: Text(
              product.description,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            )
          )            
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(builder:(BuildContext context, Widget child, MainModel model){
        Product product = model.products[index];
        return  Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: _buildProductDetails(product)
        );
      })    
    );
  }
}
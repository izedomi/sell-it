import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';
import 'package:sell_it/scoped-models/main.dart';

import '../models/product.dart';
import "./product_edit.dart";


class ProductList extends StatefulWidget {

  final MainModel model;

  ProductList(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductList>{

  void initState(){
    widget.model.fetchProduct();
    super.initState();
  }


  Widget _buildIconButton(BuildContext context, int index, MainModel model){
      
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: (){
          model.setSelectedProductIndex(index);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ProductEdit()
            )
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      List<Product> products = model.products;
      return ListView.builder(
      itemBuilder: (BuildContext context, int index){
          return Dismissible(
              key: Key(products[index].title),
              background: Container(color: Colors.red),
              onDismissed: (DismissDirection direction){
                  if(direction == DismissDirection.endToStart){
                    //delete product
                    model.setSelectedProductIndex(index);                   
                    model.deleteProduct();
                  }
              },
              child: Column(
              children: <Widget>[         
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(products[index].image)),
                  title: Text(products[index].title),
                  subtitle: Text('\$${products[index].price.toString()}'),
                  trailing: _buildIconButton(context, index, model)
                ),
                Divider(color: Colors.grey,)
              ],
            )
          );
      },
      itemCount: products.length
    );
     
    });
    
    
    
  }
}
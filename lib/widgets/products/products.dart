import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';
//import 'package:sell_it/pages/product.dart';

import "./product_card.dart";
import "../../models/product.dart";
import "../../scoped-models/main.dart";

class Products extends StatelessWidget{


  Widget _buildProductList(List<Product> products){
    Widget productCards;
    if(products.length > 0){
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    }
    else{
      productCards = Center(child: Text("No products, please add some"),);
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {


    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
        List<Product> products = model.displayedProducts;
         return _buildProductList(products); 
    });
      
  }

}

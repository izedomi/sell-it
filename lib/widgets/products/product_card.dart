import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sell_it/scoped-models/main.dart';
import 'package:sell_it/widgets/products/address_tag.dart';


import '../ui_elements/title_default.dart';
import './price_tag.dart';
import '../../models/product.dart';


class ProductCard extends StatelessWidget {

  final Product product;
  final int index;

  ProductCard(this.product, this.index);

  Widget _buildTitlePriceRow(BuildContext context){
    return  Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(width: 8.0),
          PriceTag(product.price.toString()),                
        ]
      )

    );
  }

  Widget _buildActionButtons(BuildContext context){
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
      IconButton(       
        icon: Icon(Icons.info),
        color: Theme.of(context).accentColor,
        onPressed: (){
          Navigator.pushNamed<bool>(
            context, 
            '/product/'+index.toString()                   
          ).then((bool value){
            
          });
        } , 
      ),
      ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
          return IconButton(
            icon: Icon(model.products[index].isFavourite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: (){
              model.setSelectedProductIndex(index);
              model.toggleProductFavouriteStatus();
            },
          );
      },)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5.0,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.0),
      child: Column(
        children: <Widget>[        
            FadeInImage(
              image: NetworkImage(product.image), 
              placeholder: AssetImage("assets/food.jpg"),
              fit: BoxFit.cover,
            ),
            _buildTitlePriceRow(context),
            AddressTag("Woji, Port harcourt"), 
            Text(product.userEmail), 
            _buildActionButtons(context)            
            
        ],
      ),
    );
  }
}
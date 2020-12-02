import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {

  final String price;

  PriceTag(this.price);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(4.0)
      ),
      child: Text(
        '\$$price',
        style: TextStyle(color: Colors.white),
      ) ,
    );
  }
}
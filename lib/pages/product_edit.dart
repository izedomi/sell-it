//import 'dart:ffi';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';


import '../models/product.dart';
import '../scoped-models/main.dart';
import '../models/user.dart';

class ProductEdit extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProductEditState();
  }
}

class _ProductEditState extends State<ProductEdit>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _formData = {
    'title' : null,
    'description' : null,
    'price' : null,
    'image' : "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQdBnqBZlRzaU0JS9hlNXV3QzONL0UuKySBYQ90VhPSFL-5nfZR"
  };

  Widget _buildTitleTextField(Product product){
      return TextFormField(
        decoration: InputDecoration(labelText: "Product Title"),
        validator: (String value){
            if(value.isEmpty || value.length < 3){
              return "Title is required and should be 3+ characters long";
            }
            return null;
        },
        initialValue: product == null ? "" : product.title,
        onSaved: (String value){
            _formData['title'] = value;
        },
      );
  }

  Widget _buildDescriptionTextField(Product product){
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Description"),
      validator: (String value){
            if(value.isEmpty || value.length < 5){
              return "Description is required and should be 5+ characters long";
            }
            return null;
      },
      initialValue: product == null ? "" : product.description,
      maxLines: 4,
      onSaved: (String value){
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product product){
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price"),
      keyboardType: TextInputType.number,
       validator: (String value){
            if(value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)){
              return "Price is required and should be a number";
            }
            return null;
      },
      initialValue: product == null ? "" : product.price.toString(),
      onSaved: (String value){
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton(){
      return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
        return  model.isLoading ? Center(child: CircularProgressIndicator()) : RaisedButton(
          child: Text("Save"),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectedProduct, model.setSelectedProductIndex, model.authUser)
        );
      });
  }

  Widget _buildPageContent(BuildContext context, Product product){
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
      return GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
        padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child:ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                  _buildTitleTextField(product),
                  _buildDescriptionTextField(product),
                  _buildPriceTextField(product),        
                  SizedBox(height:10.0),
                  _buildSubmitButton()
              ]
            )
          )
        )
      );


  }
  
  void _submitForm(Function addProduct, Function updateProduct, Function selectedProduct, Function setSelectedProductIndex, User authUser){
    if(!_formKey.currentState.validate()){
       return;
    }
    _formKey.currentState.save();

    if(selectedProduct() == null){
        addProduct(
        title: _formData['title'],
        description: _formData['description'],
        price: _formData['price'],
        image: _formData['image'],
        userEmail: authUser.email,
        userId: authUser.id
      ).then((bool success) {
        if(success){
            Navigator.pushReplacementNamed(context, 'products').then((_) => setSelectedProductIndex(null));
        }
        else{
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("Something went wrong"),
                content: Text("Please try again"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OKay"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    }
                  )
                ],
                );
            }
          
          );
     
        }
        
      });
    }
    else{
      updateProduct(
        title: _formData['title'],
        description: _formData['description'],
        price: _formData['price'],
        image: _formData['image'],
        userEmail: selectedProduct().userEmail,
        userId: selectedProduct().userId
      ).then((_) => Navigator.pushReplacementNamed(context, 'products').then((_) => setSelectedProductIndex(null)));
    }
    
    //Navigator.pushReplacementNamed(context, 'products').then((_) => setSelectedProductIndex(null));
  }

  @override
  Widget build(BuildContext context) {
    
      return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
        final Widget pageContent =  _buildPageContent(context, model.selectedProduct());
        return model.selectedProductIndex == null ? pageContent : Scaffold(
          appBar: AppBar(
            title: Text("Edit Product"),
          ),
          body: pageContent,
        );
      });
         
  }
}
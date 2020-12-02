import 'dart:convert';

//import 'package:http/http.dart' as http;
//import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';


//https://sell-it-bd631.firebaseio.com/

class ProductsModel extends Model{
  
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavourites = false;
  bool _isLoading = false;

  
  List<Product> get products{
    return List.from(_products);
  }

  List<Product> get displayedProducts{
     
     if(_showFavourites){
        return List.from(_products.where((Product product) => product.isFavourite).toList());
     }

     return List.from(_products);  
  }

  int get selectedProductIndex{
    if(_selectedProductIndex != null){
        return _selectedProductIndex;
    }
    return null;   
  }

  bool get displayFavouriteOnly{
    return _showFavourites;
  }

  bool get isLoading{
    return _isLoading;
  }

  Future<Null> fetchProduct(){
    _isLoading = true;
    notifyListeners();
  

    return http.get('https://sell-it-bd631.firebaseio.com/products.json')
    .then((http.Response response){
        final List<Product> fetchedProductList = [];
        Map<String, dynamic> productDataList = json.decode(response.body);

        if(productDataList == null){
          _isLoading = false;
          notifyListeners();
          return;
        }
        print(response.body);
        productDataList.forEach((String productId, dynamic productData){
            Product product = Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              image: productData['image'],
              price: productData['price'],
              userEmail: productData['userEmail'],
              userId: productData['userId']
            );

            fetchedProductList.add(product);
        });

        print(fetchedProductList.length);
        _products = fetchedProductList;
        _isLoading = false;      
        notifyListeners();

    });
  }

  Future<bool> addProduct({String title, String description, String image, double price, String userEmail, String userId}){
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': userEmail,
      'userId': userId
    };

    return http.post("https://sell-it-bd631.firebaseio.com/products", body:json.encode(productData))
      .then((http.Response response){

        /*if(response.statusCode != 200 && response.statusCode != 201){
          _isLoading = false;
          notifyListeners();
          return false;
        }*/
        Map<String, dynamic> responseData = json.decode(response.body);
        //print(responseData['name']);
        Product product = Product(
        id: responseData['name'],
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: userEmail,
        userId: userId,
      ); 
        _products.add(product);
        _selectedProductIndex = null;
        _isLoading = false;
        notifyListeners();
        return true;
    }).catchError((error){
      _isLoading = false;
      notifyListeners();
      return false;
    }); 
    
  }
     
   Future<bool> updateProduct({String title, String description, String image, double price, String userEmail, String userId}){ 

    _isLoading = true;
    notifyListeners();

     Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': userEmail,
      'userId': userId
    };

    return http.put('https://sell-it-bd631.firebaseio.com/products/${selectedProduct().id}.json', body: json.encode(updateData))
    .then((http.Response response){
      Product product = Product(
        id: selectedProduct().id,
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: userEmail,
        userId: userId,
      );  

      _isLoading = false;
      _products[_selectedProductIndex] = product; 
      _selectedProductIndex = null;
      return true;
      //notifyListeners();
             
    }).catchError((error){
      _isLoading = false;
      notifyListeners();
      return false;
    }); 
  }

  void deleteProduct(){ 
       
      http.delete("https://sell-it-bd631.firebaseio.com/products/${selectedProduct().id}.json")
      .then((http.Response response){

        _products.removeAt(_selectedProductIndex);
        _selectedProductIndex = null;
        notifyListeners();

      });
  }

  void setSelectedProductIndex(int index){
    _selectedProductIndex = index;
  }

  Product selectedProduct(){
    if(_selectedProductIndex != null){
      return _products[_selectedProductIndex];
    }
    return null;
  }

  void toggleProductFavouriteStatus(){
    Product currentProduct = selectedProduct();
    bool currentFavouriteStatus = currentProduct.isFavourite;
    bool newFavouriteStatus = !currentFavouriteStatus;
    Product updatedProduct = Product(
      id: currentProduct.id,
      title: currentProduct.title,
      description: currentProduct.description,
      price: currentProduct.price,
      image: currentProduct.image,
      userEmail: currentProduct.userEmail,
      userId: currentProduct.userId,
      isFavourite: newFavouriteStatus
    );

    if(_selectedProductIndex != null){
         _products[_selectedProductIndex] = updatedProduct; 
         _selectedProductIndex = null;
         notifyListeners();
    }   
   
  }

  void toggleDisplayMode(){
    _showFavourites = !_showFavourites;
    notifyListeners();
  }

 
}
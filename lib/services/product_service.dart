import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/model.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  final String _baseUrl = "flutter-varios-69ed4-default-rtdb.firebaseio.com";
  final List<Product> productos = [];
  late Product selectedProduct;

  File? pictureFile;

  bool isLoading = true;
  bool isSaving = false;


  ProductService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);
    
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      productos.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return productos;
    
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if(product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toRawJson());
    final decodeData = resp.body;

    final index = productos.indexWhere((element) => element.id == product.id);
    productos[index] = product;

    return product.id!;

  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/.json');
    final resp = await http.post(url, body: product.toRawJson());
    final decodeData = json.decode(resp.body);

    product.id = decodeData['name'];

    productos.add(product);

    return product.id!;

  }

  Future deleteProduct(Product product) async {

    isSaving = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    await http.delete(url);
    
    productos.removeWhere((producto) => producto.id == product.id);

    isSaving = false;
    notifyListeners();
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    pictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if(pictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dqycrsnnf/image/upload?upload_preset=o829wgpm');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', pictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    pictureFile = null;

    final decodeData = json.decode(resp.body);

    return decodeData['secure_url'];

  }

}
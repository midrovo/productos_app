import 'package:flutter/material.dart';
import 'package:productos_app/models/model.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productsServices = Provider.of<ProductService>(context);
    if(productsServices.isLoading) return const LoadingScreen();

    final List<Product> productos = productsServices.productos;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos', style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () {
            productsServices.selectedProduct = productos[i].copy();
            Navigator.pushNamed(context, 'products');
            },
          child: ProductCard(product: productos[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          productsServices.selectedProduct = Product(
              available: true,
              name: "",
              price: 0.00);
          Navigator.pushNamed(context, 'products');
        },
      ),
    );
  }
}
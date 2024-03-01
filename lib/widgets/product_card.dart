import 'package:flutter/material.dart';
import 'package:productos_app/models/model.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorder(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(urlImage: product.picture),

            _ProductDetails(
              nameProduct: product.name,
              idProduct: product.id,
            ),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(
                priceProduct: product.price,
              ),
            ),

            if(!product.available)
              const Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable(),
              ),

          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorder() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 7),
        blurRadius: 10,
      )
    ]
  );
}

class _BackgroundImage extends StatelessWidget {

  final String? urlImage;

  const _BackgroundImage({super.key, this.urlImage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: urlImage == null ? const Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover,) :
        FadeInImage(
          placeholder: const AssetImage("assets/jar-loading.gif"),
          image: NetworkImage(urlImage!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {

  final String nameProduct;
  final String? idProduct;

  const _ProductDetails({super.key, required this.nameProduct, required this.idProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        width: double.infinity,
        height: 75,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nameProduct,
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(idProduct != null ? idProduct! : 'S/N',
              style: const TextStyle(fontSize: 15, color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
  );
}

class _PriceTag extends StatelessWidget {

  final double priceProduct;

  const _PriceTag({super.key, required this.priceProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 75,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('\$$priceProduct', style: const TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {

  const _NotAvailable({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('No disponible',
          style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}





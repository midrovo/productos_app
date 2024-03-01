import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? urlImage;

  const ProductImage({super.key, this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          child: getImage(urlImage),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 5)
      )
    ]
  );

  Widget getImage(String? picture) {
    if(picture == null) {
      return const Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover,);
    }

    if(picture.startsWith('http')) {
      return FadeInImage(
        image: NetworkImage(urlImage!),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }

}

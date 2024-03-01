import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/service.dart';
import 'package:productos_app/ui/input_decoration.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductService>(context);

    //return _ProductScreenBody(productService: productService);
    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( productService.selectedProduct ),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {

  final ProductService productService;

  const _ProductScreenBody({required this.productService});

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(urlImage: productService.selectedProduct.picture),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white,),
                    )
                ),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final imagePicker = ImagePicker();
                        final XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 100
                        );

                        if(file == null) {
                          print('No selecciono nada');
                          return;
                        }
                        productService.updateSelectedProductImage(file.path);

                      },
                      icon: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,),
                    )
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline_outlined, size: 40, color: Colors.red,),
                    onPressed: () async {
                      productService.deleteProduct(productForm.product);
                    },
                  ),
                )
              ],
            ),

            _ProductForm(),

            const SizedBox(height: 100,),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving ? const CircularProgressIndicator(color: Colors.white,) :
        const Icon(Icons.save_outlined, color: Colors.white,),
        onPressed: () async {
          if(!productForm.isValidForm()) return;

          final String? imageUrl = await productService.uploadImage();

          if(imageUrl != null) productForm.product.picture = imageUrl;

          await productService.saveOrCreateProduct(productForm.product);
        },
      ),
    );
  }
}


class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: productForm.formKey,
          child: Column(
            children: [
              const SizedBox(height: 10,),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if(value == null || value.isEmpty)
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:'
                ),
              ),

              const SizedBox(height: 30,),

              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                keyboardType: TextInputType.number,
                initialValue: '${product.price}',
                onChanged: (value) {
                  if(double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150.00',
                    labelText: 'Precio:'
                ),
              ),

              const SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productForm.updateAvailability,
              ),

              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 5),
        blurRadius: 5
      )
    ]
  );

}


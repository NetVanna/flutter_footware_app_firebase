import 'package:flutter/material.dart';
import 'package:footware_admin/controller/home_controller.dart';
import 'package:footware_admin/widgets/input_field.dart';
import 'package:get/get.dart';
import '../widgets/drop_down_button.dart';

class UpdateProduct extends StatelessWidget {
  const UpdateProduct({super.key, required this.controller, required this.index});
  final HomeController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final product = controller.products[index];

    // Prefill controllers with existing product details
    controller.productNameController.text = product.name ?? "";
    controller.productDescriptionController.text = product.description ?? "";
    controller.productImageController.text = product.image ?? "";
    controller.productPriceController.text = product.price.toString();
    controller.category = product.category ?? "general";
    controller.brand = product.brand ?? "no brand";
    controller.offer = product.offer ?? false;

    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Update Product",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.indigo),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                "Update Product",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.indigo),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      InputField(
                        controller: controller.productNameController,
                        validator: (value) => value == null || value.isEmpty ? "Please enter product name" : null,
                        label: "Product Name",
                        hintText: "Enter Product Name",
                        showIcon: true,
                        prefixIcon: Icons.title,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        controller: controller.productDescriptionController,
                        validator: (value) => value == null || value.isEmpty ? "Please enter product description" : null,
                        label: "Product Description",
                        hintText: "Enter Product Description",
                        maxLines: 5,
                        showIcon: true,
                        prefixIcon: Icons.description_outlined,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        controller: controller.productImageController,
                        validator: (value) => value == null || value.isEmpty ? "Please enter image url" : null,
                        label: "Image Url",
                        hintText: "Enter Image url",
                        showIcon: true,
                        prefixIcon: Icons.image,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        controller: controller.productPriceController,
                        validator: (value) => value == null || value.isEmpty ? "Please enter product price" : null,
                        label: "Product Price",
                        hintText: "Enter Product Price",
                        showIcon: true,
                        prefixIcon: Icons.price_change_outlined,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropDownButton(
                              items: ['Boots', 'Shoe', 'Beach Shoes', 'High heels'],
                              selectedItems: controller.category,
                              onChanged: (selectedItems) {
                                controller.category = selectedItems ?? "general";
                                controller.update();
                              },
                            ),
                          ),
                          Expanded(
                            child: DropDownButton(
                              items: ['Puma', 'Sketchers', 'Adidas', 'Clark'],
                              selectedItems: controller.brand,
                              onChanged: (selectedItems) {
                                controller.brand = selectedItems ?? "no brand";
                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Offer?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropDownButton(
                          items: ['true', 'false'],
                          selectedItems: controller.offer.toString(),
                          onChanged: (selectedItems) {
                            controller.offer = selectedItems == 'true';
                            controller.update();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.updateProduct(index);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                        child: const Text("Update Product"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

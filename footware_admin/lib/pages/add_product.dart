import 'package:flutter/material.dart';
import 'package:footware_admin/controller/home_controller.dart';
import 'package:footware_admin/widgets/input_field.dart';
import 'package:get/get.dart';

import '../widgets/drop_down_button.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.indigo),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Add New Product",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo,
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      InputField(
                        controller: controller.productNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter product name";
                          }
                          return null;
                        },
                        label: "Product Name",
                        hintText: "Enter Product Name",
                        showIcon: true,
                        prefixIcon: Icons.title,
                      ),
                      SizedBox(height: 20),
                      InputField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter product description";
                          }
                          return null;
                        },
                        controller: controller.productDescriptionController,
                        label: "Product Description",
                        hintText: "Enter Product Description",
                        maxLines: 5,
                        showIcon: true,
                        prefixIcon: Icons.description_outlined,
                      ),
                      SizedBox(height: 20),
                      InputField(
                        controller: controller.productImageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter image url";
                          }
                          return null;
                        },
                        label: "Image Url",
                        hintText: "Enter Image url",
                        showIcon: true,
                        prefixIcon: Icons.image,
                      ),
                      SizedBox(height: 20),
                      InputField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter product price";
                          }
                          return null;
                        },
                        controller: controller.productPriceController,
                        label: "Product Price",
                        hintText: "Enter Product Price",
                        showIcon: true,
                        prefixIcon: Icons.price_change_outlined,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropDownButton(
                              items: [
                                'Boots',
                                'Shoe',
                                'Beach Shoes',
                                'High hells'
                              ],
                              selectedItems: controller.category.toString(),
                              onChanged: (selectedItems) {
                                controller.category =
                                    selectedItems ?? "general";
                                controller.update();
                              },
                            ),
                          ),
                          Expanded(
                            child: DropDownButton(
                              items: ['puma', 'sketches', 'adidas', 'clark'],
                              selectedItems: controller.brand.toString(),
                              onChanged: (selectedItems) {
                                controller.brand = selectedItems ?? "no brand";
                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Offer?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropDownButton(
                          items: ['true', 'false'],
                          selectedItems: controller.offer.toString(),
                          onChanged: (selectedItems) {
                            controller.offer =
                                bool.tryParse(selectedItems.toString()) ??
                                    false;
                            controller.update();
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.addProduct();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white),
                        child: Text("Add Product"),
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

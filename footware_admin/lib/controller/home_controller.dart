import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_admin/models/product.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //Creates an instance of Firestore.

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Declares productCollection to store product data.
  late CollectionReference productCollection;

  // Controllers for managing text input fields.
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productImageController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  // default value
  String category = 'general';
  String brand = 'no brand';
  bool offer = false;

  // Stores data fetched products from firebase.
  List<Product> products = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    await fetchProducts();
    super.onInit();
  }

  addProduct() {
    try {
      // Creates a Firestore document reference.
      DocumentReference documentReference = productCollection.doc();
      // Creates a Product object with user input.
      Product product = Product(
        id: documentReference.id,
        name: productNameController.text,
        description: productDescriptionController.text,
        image: productImageController.text,
        category: category,
        brand: brand,
        offer: offer,
        price: double.tryParse(productPriceController.text),
      );
      // Converts Product into JSON
      final productJson = product.toJson();
      // stores it in Firestore
      documentReference.set(productJson);
      fetchProducts();
      Get.back();
      // show msg
      Get.snackbar(
        'Success',
        "Add product successfully!",
        colorText: Colors.green,
      );
      // reset value
      setDefaultValue();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.red,
      );
    }
  }

  // show data from firebase
  fetchProducts() async {
    try {
      QuerySnapshot productSnapShot = await productCollection.get();
      final List<Product> retrieveProducts = productSnapShot.docs
          .map(
            (docs) => Product.fromJson(docs.data() as Map<String, dynamic>),
          )
          .toList();
      products.clear();
      products.assignAll(retrieveProducts);
      // Get.snackbar(
      //   'Success',
      //   'Product fetch all successfully',
      //   colorText: Colors.green,
      // );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.red,
      );
    } finally {
      update();
    }
  }

  // delete product
  deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      fetchProducts();
      Get.snackbar(
        'Success',
        'Product delete successfully',
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.red,
      );
    } finally {
      update();
    }
  }

  // Update an existing product
  void updateProduct(int index) async {
    try {
      // Validate if price is a valid number
      double price = double.tryParse(productPriceController.text) ?? -1;
      if (price < 0) {
        throw Exception("Invalid price entered");
      }

      // Get the product ID
      String? productId = products[index].id;

      // Create updated product data
      Map<String, dynamic> updatedData = {
        "name": productNameController.text.trim(),
        "description": productDescriptionController.text.trim(),
        "image": productImageController.text.trim(),
        "price": price,
        "category": category,
        "brand": brand,
        "offer": offer,
      };

      // Update Firestore document
      await productCollection.doc(productId).update(updatedData);

      // Update local list
      products[index] = Product(
        id: productId,
        name: updatedData["name"],
        description: updatedData["description"],
        image: updatedData["image"],
        price: updatedData["price"],
        category: updatedData["category"],
        brand: updatedData["brand"],
        offer: updatedData["offer"],
      );

      update(); // Refresh UI
      Get.back(); // Navigate back to home page

      // Show success message
      Get.snackbar(
        "Success",
        "Product updated successfully",
        colorText: Colors.green,
      );
    } catch (e) {
      // Show error message
      Get.snackbar(
        "Error",
        "Failed to update product: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // reset value function
  setDefaultValue() {
    productNameController.clear();
    productDescriptionController.clear();
    productImageController.clear();
    productPriceController.clear();
    category = 'general';
    brand = 'no brand';
    offer = false;
    update();
  }
}

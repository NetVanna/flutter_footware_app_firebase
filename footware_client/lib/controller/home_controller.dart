import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_client/models/product_category/product_category.dart';
import 'package:get/get.dart';

import '../models/product_model/product.dart';

class HomeController extends GetxController {
  //Creates an instance of Firestore.

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Declares productCollection to store product data.
  late CollectionReference productCollection;
  late CollectionReference productCategoryCollection;

  // Stores data fetched products from firebase.
  List<Product> products = []; // all product
  List<Product> productFilter = []; // list product by filter category
  List<ProductCategory> productsCategory = [];

  String selectedCategory = "All"; // Track selected category
  List<String> selectedBrands = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    productCategoryCollection = firestore.collection("category");
    await fetchProducts();
    await fetchProductsCategory();
    super.onInit();
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
      productFilter.assignAll(products);
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

  // show data from firebase
  fetchProductsCategory() async {
    try {
      QuerySnapshot productCategorySnapShot =
          await productCategoryCollection.get();
      final List<ProductCategory> retrieveProductsCategory =
          productCategorySnapShot.docs
              .map(
                (docs) => ProductCategory.fromJson(
                    docs.data() as Map<String, dynamic>),
              )
              .toList();
      productsCategory.clear();
      productsCategory.assignAll(retrieveProductsCategory);
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

  filterByCategory(String category) {
    selectedCategory = category; // Update selected category
    productFilter.clear();
    if (category == "All") {
      productFilter = List.from(products); // Show all products
    } else {
      productFilter =
          products.where((product) => product.category == category).toList();
    }
    update();
  }

  searchProducts(String query) {
    if (query.isEmpty) {
      productFilter
          .assignAll(products); // Reset to all products if search is empty
    } else {
      productFilter = products
          .where((product) =>
              product.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  filterByBrand(List<String> brand) {
    selectedBrands = brand;
    if (brand.isEmpty) {
      productFilter =
          List.from(products); // Reset filter if no brand is selected
    } else {
      List<String> lowerBrands = brand.map((b) => b.toLowerCase()).toList();

      productFilter = products.where((product) {
        return product.brand != null &&
            lowerBrands.contains(product.brand!.toLowerCase());
      }).toList();
    }
    update(); // Refresh UI
  }

  sortByPrice(bool ascending) {
    List<Product> sortedProduct = List<Product>.from(productFilter);
    sortedProduct.sort((a, b) => ascending
        ? a.price!.compareTo(b.price!)
        : b.price!.compareTo(a.price!));
    productFilter = sortedProduct;
    update();
  }
}

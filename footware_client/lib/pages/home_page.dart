import 'package:flutter/material.dart';
import 'package:footware_client/controller/home_controller.dart';
import 'package:footware_client/pages/login_page.dart';
import 'package:footware_client/pages/product_details.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/drop_down_button.dart';
import '../widgets/multi_selected_drop_down.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    List<String> selectedItems = [];
    return GetBuilder<HomeController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          // Fetch categories and products from API or database
          await controller.fetchProductsCategory(); // Ensure categories update
          await controller.fetchProducts(); // Fetch all products
          controller.selectedCategory = "All"; // Reset selection
          selectedValue = null;
          selectedItems = [];
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "FootWare Store",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  GetStorage box = GetStorage();
                  box.erase();
                  Get.offAll(LoginPage());
                },
                icon: Icon(Icons.logout_outlined),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **Search Field**
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (query) {
                    controller.searchProducts(query); // Call search function
                  },
                ),

                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: controller.productsCategory.length + 1,
                    // +1 for "All" button
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String categoryName = index == 0
                          ? "All"
                          : controller.productsCategory[index - 1].name ??
                              "No Category";
                      bool isSelected = controller.selectedCategory ==
                          categoryName; // Corrected selection check

                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.filterByCategory(categoryName);
                            controller.selectedCategory =
                                categoryName; // Update selected category
                          },
                          child: Chip(
                            label: Text(categoryName),
                            backgroundColor:
                                isSelected ? Colors.blue : Colors.grey[300],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: MultiSelectedDropDown(
                        items: ['adidas', 'puma', 'boots'],
                        onSelectionChanged: (selectedItems) {
                          controller.filterByBrand(selectedItems);
                          controller.selectedBrands =
                              selectedItems; // Store in the controller
                          controller.update(); // Update UI
                        },
                        selectedItem: selectedItems.isEmpty
                            ? "Brands"
                            : selectedItems.join(", "), // ✅ Dynamic label
                        selectedItems: selectedItems,
                      ),
                    ),
                    Expanded(
                      child: DropDownButton(
                        items: ['Low-High', 'High-Low'],
                        onChanged: (value) {
                          controller
                              .sortByPrice(value == "Low-High" ? true : false);
                          selectedValue = value;
                        },
                        selectedItems: selectedValue ?? "Sort Price",
                        value: selectedValue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: controller.productFilter.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "No products available",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: controller.productFilter.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            final products = controller.productFilter[index];
                            return ProductCard(
                              name: products.name ?? "No Name",
                              price: '\$${products.price}',
                              imageUrl: products.image ??
                                  "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg",
                              discount: "05",
                              onTap: () {
                                Get.to(ProductDetails(),arguments: {"data":controller.productFilter[index]});
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

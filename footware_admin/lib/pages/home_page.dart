import 'package:flutter/material.dart';
import 'package:footware_admin/controller/home_controller.dart';
import 'package:footware_admin/pages/add_product.dart';
import 'package:footware_admin/pages/update_product.dart';
import 'package:get/get.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "FootWare Admin",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
            ),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.products[index].name ?? "No Product Name"),
                  subtitle: Text("\$${controller.products[index].price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(UpdateProduct(controller: controller, index: index,));
                        },
                        icon: Icon(Icons.edit,color: Colors.indigo,),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.deleteProduct(controller.products[index].id.toString());
                        },
                        icon: Icon(Icons.delete,color: Colors.red,),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: controller.products.length,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(AddProduct());
            },
            backgroundColor: Colors.indigo,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      }
    );
  }
}

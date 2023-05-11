


import 'package:bomhamburguer/src/data/data_base/product_DAO.dart';

import '../../data/model/product_model.dart';

class ProductRepository {
  final productDao = ProductDao();

  Future<List<ProductModel>> fetchAllProducts() async {

    List<ProductModel> temp = await productDao.readProducts();

    return temp;

  }

  Future<dynamic> createProduct(int id, String name, double price, String urlImage) async {

    ProductModel productModel = ProductModel(id, name, price, urlImage);
    print(">>> en repository");

    await productDao.createProduct(productModel);

    return "OK";

  }

  Future<bool> validateIsEmpty() async {
    List<ProductModel> temp = await productDao.readProducts();
    return temp.isEmpty;

  }

  Future<List<ProductModel>> fetchProductsByIds(List<int> list) async {

    List<ProductModel> temp = await productDao.readByIds(list);

    return temp;

  }
}
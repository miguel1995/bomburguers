/*
* Contiene los metodos DAO Data Access Object
* Son metodos que permiten hacer las operaciones CRUD sobre la base de datos
* */


import '../model/product_model.dart';
import 'database.dart';

class ProductDao {

  final dbProvider = DatabaseProvider.dbProvider;

  // ##### CRUD  de eventos  #######

  //Nuevo registro de circulasEvent
  Future<int> createProduct(ProductModel productModel) async {
    print(">>> en DAO");

    final db = await dbProvider.getDataBase();

    print(productTable);
    print(productModel.toMap().toString());

    var result = db.insert(productTable, productModel.toMap());
    return result;
  }

  Future<List<ProductModel>> readProducts() async {
    final db = await dbProvider.getDataBase();

    List<Map<String, dynamic>> result;

    String query =
        "SELECT * FROM $productTable";

    result = await db.rawQuery(query);

    List<ProductModel> events = result.isNotEmpty
        ? List.generate(result.length, (i) {
      return ProductModel(
          result[i]['id'],
          result[i]['name'],
          result[i]['price'],
          result[i]['urlImage']
      );
    })
        : [];

    return events;
  }

  Future<List<ProductModel>> readByIds(List<int> list) async {
    final db = await dbProvider.getDataBase();

    List<Map<String, dynamic>> result;

    String listStr = list.toString();
    listStr = listStr.replaceAll('[', '(');
    listStr = listStr.replaceAll(']', ')');

    String query =
        "SELECT * FROM $productTable WHERE id IN $listStr";
    print(">>> Query SQL");
    print(query);

    result = await db.rawQuery(query);

    List<ProductModel> events = result.isNotEmpty
        ? List.generate(result.length, (i) {
      return ProductModel(
          result[i]['id'],
          result[i]['name'],
          result[i]['price'],
          result[i]['urlImage']
      );
    })
        : [];

    return events;
  }


}

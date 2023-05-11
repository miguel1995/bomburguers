import 'package:bomhamburguer/src/business_logic/repositories/product_repository.dart';
import 'package:bomhamburguer/src/data/model/product_model.dart';
import 'package:rxdart/rxdart.dart';


class ProductListBloc{

  final _repository = ProductRepository();
  final _subject = BehaviorSubject<List<ProductModel>>();

  fetchAllProducts() async {

    List<ProductModel> productModel = await _repository.fetchAllProducts();
    _subject.sink.add(productModel);

  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<ProductModel>> get subject => _subject;
}
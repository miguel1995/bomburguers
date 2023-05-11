import 'package:bomhamburguer/src/business_logic/repositories/product_repository.dart';
import 'package:bomhamburguer/src/data/model/product_model.dart';
import 'package:rxdart/rxdart.dart';


class ProductListByIdsBloc{

  final _repository = ProductRepository();
  final _subject = BehaviorSubject<List<ProductModel>>();

  fetchProductsByIds(List<int> list) async {

    List<ProductModel> productModel = await _repository.fetchProductsByIds(list);
    _subject.sink.add(productModel);

  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<ProductModel>> get subject => _subject;
}
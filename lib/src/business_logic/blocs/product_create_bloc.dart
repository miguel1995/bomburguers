import 'package:rxdart/rxdart.dart';

import '../repositories/product_repository.dart';

class ProductCreateBloc{

  final _repository = ProductRepository();
  final _subject = BehaviorSubject<dynamic>();

  createProduct(int id, String name, double price, String urlImage) async {

    print(">>> en bloc");

    dynamic result = await _repository.createProduct( id,  name,  price,  urlImage);
    _subject.sink.add(result);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<dynamic> get subject => _subject;

}
import 'package:bomhamburguer/src/business_logic/repositories/product_repository.dart';
import 'package:bomhamburguer/src/data/model/product_model.dart';
import 'package:rxdart/rxdart.dart';


class ProductEmptyBloc{

  final _repository = ProductRepository();
  final _subject = BehaviorSubject<bool>();

  isEmpty() async {

    bool res = await _repository.validateIsEmpty();
    _subject.sink.add(res);

  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<bool> get subject => _subject;
}
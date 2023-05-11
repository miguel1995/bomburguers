class ProductModel {

  int _id;
  String _name;
  double _price;
  String _urlImage;


  ProductModel(this._id, this._name, this._price, this._urlImage);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'urlImage':urlImage
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) =>
      ProductModel(json["id"],json["name"], json["price"],json["imageUrl"]);

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, price: $price, urlImage: $urlImage}';
  }
}

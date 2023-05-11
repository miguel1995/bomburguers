

import 'package:bomhamburguer/src/presentation/partials/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/blocs/product_listbyids_bloc.dart';
import '../../data/model/product_model.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {

  List<String> productsToBuy = [];
  List productList = [];
  late SharedPreferences prefs;
  ProductListByIdsBloc productListByIdsBloc = ProductListByIdsBloc();
  double cost = 0.0;
  double costTotal = 0.0;
  double porcentage = 0.0;
  String message ="";
  String name = "";


  @override
  void initState() {
    // obtain shared preferences
    initialPreference();
  }

  Future<void> initialPreference() async {
    prefs  = await SharedPreferences.getInstance();

    productsToBuy = prefs.getStringList("productsToBuy")!;
    print(">>> prefs ids");
    print(productsToBuy);

    productListByIdsBloc.fetchProductsByIds(productsToBuy.map(int.parse).toList());
    productListByIdsBloc.subject.stream.listen((event) {


      setState((){
        productList = event;
      });

      updateData();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBarPartial(),
      body: Column(
        children: [
          drawDiscounts(),
          buildList(productList),
          drawTotal(),
          btnBuy()
        ],
      ),

    );
  }

  Widget buildList(List list){
    List<Widget> listWidget = <Widget>[];

    for (var element in list) {
      listWidget.add(buildCard(element));
    }

    return Expanded(child:

    ListView(
        padding: const EdgeInsets.all(8),
        children: listWidget
    ));
  }

  Widget buildCard(ProductModel item) {
    return
      Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.amberAccent,
        child:
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox(
              width: 100,
            child: Flexible(
                child: Image.network(item.urlImage)
            )),
            Column(
              children: [
                  Text(item.name),
                  Text(
                    '\$' + item.price.toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  )
              ],
            ),
          IconButton(onPressed: (){
              productList.removeWhere((e) => e.id == item.id);
              setState(() {
                productList = productList;
              });

              productsToBuy.remove(item.id.toString());

              prefs.setStringList("productsToBuy", productsToBuy);
              print(prefs.getStringList("productsToBuy"));


              updateData();

          }, icon: Icon(Icons.highlight_remove, color: Colors.red,))
          ]
        )


      );

  }

  Widget drawTotal(){

    return Container(
      child: Text("Total: \$$cost",
        style: TextStyle(fontSize: 25)

      ),

    );
  }

  Widget btnBuy(){
    return Container(
      child: ElevatedButton(onPressed: () {

        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(children: [
                    const Icon(
                      Icons.person,
                      color: Colors.yellow,
                    ),
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        child:
                        Text('Please enter your name to continue with the payment')
                    ),
                    TextField(
                        onChanged: (text) {

                          setState(() {
                            name= text;
                          });
                        print('First text field: $text');
                      },
                    ),


                  ]),
                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Column(children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.yellow,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child:
                                      Text('$name,  Your payment has been made successfully, you will soon receive your order')
                                  )]),
                                const SizedBox(height: 15),

                                TextButton(
                                  onPressed: () {

                                    productsToBuy=[];
                                    productList=[];

                                    setState(() {
                                      productList = productList;
                                    });
                                    prefs.setStringList("productsToBuy", productsToBuy);
                                    updateData();

                                    Navigator.pop(context);

                                  },
                                  child: const Text('Close'),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );


                    },
                    child: const Text('Pay'),
                  ),

                ],
              ),
            ),
          ),
        );

      }, child: Text("Pay bill"),

      )
    );
  }

  Widget drawDiscounts(){

    return Container(
      padding: EdgeInsets.all(40),
      child: Text(message),
    );
  }

  void updateData(){

    String msg = "";

    porcentage=0.0;
    cost=0.0;
    costTotal=0.0;


    if(
    ( productsToBuy.contains("1") ||
        productsToBuy.contains("2") ||
        productsToBuy.contains("3") ) &&
        productsToBuy.contains("4") &&
        productsToBuy.contains("5")
    ){
      porcentage = 0.2;
      msg = "¡ Congratulations !  you has a 20% discount, because you selected a sandwich, fries and a soft drink";
    }else  if(
    ( productsToBuy.contains("1") ||
        productsToBuy.contains("2") ||
        productsToBuy.contains("3") ) &&
        productsToBuy.contains("5")
    ){
      porcentage = 0.15;
      msg = "¡ Congratulations !  you has a 15% discount, because you selected a sandwich and a soft drink";
    }else  if(
    ( productsToBuy.contains("1") ||
        productsToBuy.contains("2") ||
        productsToBuy.contains("3") ) &&
        productsToBuy.contains("4")
    ){
      porcentage = 0.10;
      msg = "¡ Congratulations !  you has a 10% discount, because you selected a sandwich and fries";
    }

    for (var element in productList) {
      cost+= element.price;
    }
    costTotal = cost;

    setState(() {
      costTotal = cost;
      cost = costTotal-(costTotal * porcentage);
      message = msg;
    });
  }

}

import 'package:bomhamburguer/src/business_logic/blocs/product_create_bloc.dart';
import 'package:bomhamburguer/src/business_logic/blocs/product_empty_bloc.dart';
import 'package:bomhamburguer/src/business_logic/blocs/product_list_bloc.dart';
import 'package:bomhamburguer/src/data/model/product_model.dart';
import 'package:bomhamburguer/src/presentation/partials/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List productList = [];

  List<String> productsToBuy = [];

  late SharedPreferences prefs;

  ProductCreateBloc productCreateBloc = ProductCreateBloc();
  ProductListBloc productListBloc = ProductListBloc();
  ProductEmptyBloc productEmptyBloc = ProductEmptyBloc();


  @override
  void initState() {

    // obtain shared preferences
   initialPreference();
   fullDataBase();

  }

  fullDataBase() async {

    print("Voy a llenar la tabla");
    productEmptyBloc.isEmpty();
    productEmptyBloc.subject.stream.listen((event) {
      print(event);
      if(event==true){
        productCreateBloc.createProduct(1,"X Burguer", 5.00, "https://cdn.veganrecipeclub.org.uk/wp-content/uploads/2021/06/mega-burger.jpg");
        productCreateBloc.createProduct(2, "X Egg", 4.50, "https://chatelaine.com/wp-content/uploads/2020/06/CHE07_WEB_FD_BURGERS_1280x960_STEAKANDEGG.jpg");
        productCreateBloc.createProduct(3, "X Bacom", 7.00, "https://images-gmi-pmc.edge-generalmills.com/6467a87b-0186-410b-bf19-96ed4dc32936.jpg");
        productCreateBloc.createProduct(4, "Fries", 2.00, "https://img.taste.com.au/2z0hUTnc/w1200-h630-cfill/taste/2016/11/rachel-87711-2.jpeg");
        productCreateBloc.createProduct(5, "Soft drink", 2.50, "https://cdn.shopify.com/s/files/1/0068/3750/2012/products/Soft_Drinks_375ml_600x.jpg?v=1564464058");

        productCreateBloc.subject.stream.listen((event) {
      loadData();
    });
      }else{
        loadData();
      }

    });

  }

  loadData(){

    productListBloc.fetchAllProducts();
    productListBloc.subject.stream.listen((event) {
      print(event);

      setState((){
        productList = event;
      });

    });
  }



  Future<void> initialPreference() async {
    prefs  = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:  AppBarPartial(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 5, top: 20, bottom: 10),
              child:Text("The best food that will give you joy")
          ),
          buildList(productList)
        ],
      )

    );
  }

  Widget buildList(List list){
    List<Widget> listWidget = <Widget>[];

    for (var element in list) {
      listWidget.add(buildCard(element));
    }


    return Expanded(child:

    GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
      children: listWidget
    ));
  }

  Widget buildCard(ProductModel item) {
    return
      Expanded(child:
      Card(
      color: Colors.amberAccent,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: IconButton(onPressed: (){

              print("agegar a carrito");

              productsToBuy = prefs.getStringList("productsToBuy")!;
              setState(() {
                productsToBuy=productsToBuy;
              });


              if(productsToBuy.contains(item.id.toString())){

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
                                Text('Sorry, you already added this product to the cart. Select a different one.')
                            )]),
                          const SizedBox(height: 15),

                          TextButton(
                            onPressed: () {


                              Navigator.pop(context);

                            },
                            child: const Text('Close'),
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              }else {
                productsToBuy.add(item.id.toString());
                prefs.setStringList("productsToBuy", productsToBuy);
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Column(children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.yellow,
                                ),
                                Container(
                                    padding: const EdgeInsets.all(20.0),
                                    child:
                                    Text('${item
                                        .name} has been added to your shopping cart')
                                )
                              ]),
                              const SizedBox(height: 15),
                              Flexible(child:
                              Image.network(item.urlImage)

                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Continue buying'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, '/buy');
                                },
                                child: const Text('Go cart'),
                              ),
                            ],
                          ),
                        ),
                      ),
                );
              }

            },
                icon: Container(
                  padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child:Icon(Icons.add_shopping_cart_sharp, color: Colors.deepOrange)
                )
            ),
            title:  Text(item.name),
            subtitle: Text(
              '\$' + item.price.toString(),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          Flexible(child:
          Image.network(item.urlImage)

          ),
        ],
      ),
    ));

  }


  }

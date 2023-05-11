

import 'package:flutter/material.dart';


class AppBarPartial extends StatelessWidget implements PreferredSizeWidget {

  const AppBarPartial({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      title: Image.asset("assets/logo.png",
      width: 200,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {

            Navigator.pushNamed(context, "/buy");

          },
        ),
      ],

    );
  }
}

import 'package:flutter/material.dart';
import 'package:sku_app/views/add_produce_item/add_produce_item.dart';
import 'package:sku_app/views/debug/view_product_item.dart';
import 'package:sku_app/views/account/account.dart';
import 'package:sku_app/views/qr_code/qr_code.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sku_app/providers.dart';

class TitleAppbar extends StatelessWidget with PreferredSizeWidget {
  final String pageTitle;
  @override
  final Size preferredSize = Size.fromHeight(60);
  TitleAppbar(this.pageTitle, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final currentUser = watch(userProvider).state;
      return AppBar(
        title: Text(pageTitle),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Account()));
          },
          icon: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => AddProduceItem()));
          //   },
          //   icon: Icon(
          //     Icons.bug_report,
          //     color: Colors.white,
          //   ),
          // ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => ProductItem()));
          //   },
          //   icon: Icon(
          //     Icons.bug_report,
          //     color: Colors.white,
          //   ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          QrCode(currentUser.userID, "home")));
            },
            icon: Icon(
              Icons.qr_code_sharp,
              color: Colors.white,
            ),
          )
        ],
      );
    });
  }
}

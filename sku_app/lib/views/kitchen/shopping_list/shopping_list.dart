import 'package:flutter/material.dart';
import 'package:sku_app/views/kitchen/shopping_list/shopping_list_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShoppingListViewModel>.reactive(
      viewModelBuilder: () => ShoppingListViewModel(context),
      onModelReady: (model) {
        if (model.recommendations.isEmpty) {
          model.populateShoppingList();
          model.populateRecommendations();
        }
      },
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text(
              "Your Shopping List",
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.4,
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: model.shoppingList.length,
            itemBuilder: (context, index) {
              return Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        '${model.shoppingList[index]}',
                        textScaleFactor: 1.3,
                      ),
                    ),
                    Container(
                      width: 70,
                      padding: EdgeInsets.only(right: 5),
                      child: FlatButton(
                        color: Colors.red[400],
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Delete',
                          textScaleFactor: 0.8,
                        ),
                        onPressed: () async {
                          model.deletePressed(index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 75, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recommendations",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.4,
                      ),
                      Text(
                        "Based on frequently bought and items expiring soon",
                        //textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: model.recommendations.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Container(
                          width: 65,
                          padding: EdgeInsets.only(left: 5),
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              'Add',
                              textScaleFactor: 0.8,
                            ),
                            onPressed: () async {
                              model.addPressed(index);
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            '${model.recommendations[index]}',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';
import 'FoodOrderItemWidget.dart';
import '../repository/settings_repository.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;

  OrderItemWidget({Key key, this.expanded, this.order}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 14),
              padding: EdgeInsets.only(top: 20, bottom: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: Theme(
                data: theme,
                child: ExpansionTile(
                  initiallyExpanded: widget.expanded,
                  title: Column(
                    children: <Widget>[
                      Text('${S.of(context).order_id}: #${widget.order.id}'),
                      Text(
                        widget.order.hint == "null" ? "Deliver Now" : "Deliver at: " + widget.order.hint,
                        style: Theme.of(context).textTheme.bodyText1.apply(fontSizeFactor: 0.8),
                      ),
                      Text(
                        '${widget.order.deliveryAddress.address}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy | HH:mm').format(widget.order.dateTime),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context, style: Theme.of(context).textTheme.headline4),
                      Text(
                        '${widget.order.payment.method}',
                        style: Theme.of(context).textTheme.caption,
                      ),
//                      SizedBox(height: 10),
                    ],
                  ),
                  children: <Widget>[
                    Column(
                        children: List.generate(
                      widget.order.foodOrders.length,
                      (indexFood) {
                        return FoodOrderItemWidget(heroTag: 'mywidget.orders', order: widget.order, foodOrder: widget.order.foodOrders.elementAt(indexFood));
                      },
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getTotalOrdersPrice(widget.order) < setting.value.deliveryFeeLimit
                                  ? Helper.getPrice(widget.order.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)
                                  : Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
//                          Row(
//                            children: <Widget>[
//                              Expanded(
//                                child: Text(
//                                  '${S.of(context).tax} (${widget.order.tax}%)',
//                                  style: Theme.of(context).textTheme.bodyText1,
//                                ),
//                              ),
//                              Helper.getPrice(Helper.getTaxOrder(widget.order), context, style: Theme.of(context).textTheme.subtitle1)
//                            ],
//                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).total,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context, style: Theme.of(context).textTheme.headline4)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/OrderDetails', arguments: RouteArgument(id: widget.order.id));
                    },
                    textColor: Theme.of(context).hintColor,
                    child: Wrap(
                      children: <Widget>[Text(S.of(context).viewDetails), Icon(Icons.keyboard_arrow_right)],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 180,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor),
          alignment: AlignmentDirectional.center,
          child: Text(
            '${widget.order.orderStatus.status}',
            maxLines: 1,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}

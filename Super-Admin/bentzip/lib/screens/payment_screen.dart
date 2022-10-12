import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/info_tile.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with AutomaticKeepAliveClientMixin {
  var tiles = [
    {"asset": "assets/asset_ticket.png", "title": "Total Schools"},
    {"asset": "assets/asset_clock.png", "title": "Payment Pending"},
    {"asset": "assets/asset_check.png", "title": "Payment Done"},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: GridView.builder(
                      itemCount: 3,
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isSmall(context) ? 2 : 3,
                              // childAspectRatio: (5 / 2),
                          ),
                      itemBuilder: (context, index) {
                        var tile = tiles[index];
                        return InfoTile(tile: tile);
                      }),
                ),
              ),
            ),
            const Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

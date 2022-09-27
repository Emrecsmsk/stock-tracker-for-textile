import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tekstilstok/controller/cache/cache.dart';

class IncomeView extends StatefulWidget {
  const IncomeView({Key? key}) : super(key: key);

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cacheController = Get.put(CacheDress());
  }

  late CacheDress _cacheController;

  final String totalMoneyEarned = 'Toplam kazanılan para';
  final String totalMoneyReceived = 'Toplam alınan para';
  final String totalRemainingMoney = 'Toplam kalan para';
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Lottie.asset('assets/lottie/stitch.json'),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(totalMoneyEarned,
                            style: Theme.of(context).textTheme.headline4),
                        Text('${_cacheController.totalMoney.toString()}₺',
                            style: Theme.of(context).textTheme.headline4)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(totalMoneyReceived,
                            style: Theme.of(context).textTheme.headline4),
                        Text('${_cacheController.totalReceived.toString()}₺',
                            style: Theme.of(context).textTheme.headline4)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(totalRemainingMoney,
                            style: Theme.of(context).textTheme.headline4),
                        Text('${_cacheController.totalRemainder.toString()}₺',
                            style: Theme.of(context).textTheme.headline4)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekstilstok/controller/cache/cache.dart';
import 'package:tekstilstok/view/add_dress.dart';

import 'package:tekstilstok/view/income_view.dart';
import 'package:tekstilstok/view/stock_view.dart';

class DressStock extends StatefulWidget {
  const DressStock({Key? key}) : super(key: key);

  @override
  State<DressStock> createState() => _DressStockState();
}

class _DressStockState extends State<DressStock> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _Pages.values.length, vsync: this);
    _cacheController = Get.put(CacheDress());
    _cacheController.dressListCheck();
  }

  late final TabController _tabController;
  final double _notchedValue = 10;
  late CacheDress _cacheController;
  final String stockTracking = 'Stok Takip';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _Pages.values.length,
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _floatingActionButton(),
            appBar: AppBar(
              title: Text(stockTracking),
            ),
            body: TabBarView(
                controller: _tabController,
                children: [StockView(), IncomeView()]),
            bottomNavigationBar: _bottomAppBar()));
  }

  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
        child: TabBar(
            padding: EdgeInsets.zero,
            onTap: (int index) {},
            controller: _tabController,
            tabs: [
          Tab(
            icon: Icon(
              Icons.calculate_outlined,
              color: Colors.black,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.view_list_outlined,
              color: Colors.black,
            ),
          ),
        ]));
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Get.to(() => AddDress());
      },
      child: Icon(Icons.add),
    );
  }
}

enum _Pages { Stock, Income }

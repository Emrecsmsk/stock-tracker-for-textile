import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekstilstok/controller/cache/cache.dart';
import 'package:tekstilstok/view/dress_stock.dart';

class StockView extends StatefulWidget {
  const StockView({Key? key}) : super(key: key);

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cacheController = Get.put(CacheDress());
  }

  TextEditingController? _receivedController = TextEditingController();
  final GlobalKey<FormState> _formAddKey = GlobalKey();

  final String modelNumber = 'Model Numarası';
  final String piece = 'Adet';
  final String price = 'Fiyat';

  late CacheDress _cacheController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(price), Text(modelNumber), Text(piece)],
                ),
              ),
            )),
        Expanded(
          flex: 18,
          child: _dressList(),
        ),
      ],
    );
  }

  Container _dressList() {
    return Container(
        child: Obx(
      () => ListView.builder(
          itemCount: _cacheController.lengthDressList,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Text('${_cacheController.dressList[index].date}'),
                Stack(children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.red,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.green,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      width: MediaQuery.of(context).size.width *
                          _cacheController.dressMoney[index].green,
                      height: 50,
                    ),
                  ),
                  Container(
                    decoration: ShapeDecoration(shape: StadiumBorder()),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ListTile(
                      onTap: () {
                        _dialog(index);
                      },
                      trailing: Text(
                          '${_cacheController.dressList[index].piece.toString()}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: Colors.white)),
                      leading: Text(
                        "${_cacheController.dressList[index].price.toString()}₺",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
                      title: Center(
                        child: Text(
                            _cacheController.dressList[index].id.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ]),
                Divider(
                  thickness: 2,
                  color: Colors.black,
                )
              ],
            );
          }),
    ));
  }

  Future<dynamic> _dialog(int index) {
    return Get.defaultDialog(
        title: 'Model:${_cacheController.dressList[index].id.toString()}',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Toplam Para'),
            Text(_cacheController.dressMoney[index].total.toString()),
            Text('Kalan para'),
            Text(_cacheController.dressMoney[index].remainder.toString()),
            Text('Aldığın para'),
            Text(_cacheController.dressMoney[index].received.toString()),
            Form(
              key: _formAddKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Aldığın para'),
                    controller: _receivedController,
                    keyboardType: TextInputType.number,
                    validator: (String? data) => (data!.length > 0
                            ? int.parse(data) >
                                _cacheController.dressMoney[index].remainder
                            : false)
                        ? 'Kalan paradan daha fazla ödeme alamazsın!'
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (_formAddKey.currentState?.validate() ?? false) {
                              _cacheController.addModelMoney(
                                  index,
                                  int.parse(_receivedController!.text == ''
                                      ? '0'
                                      : _receivedController!.text));
                              _cacheController.lengthDressList =
                                  await _cacheController.lengthDressList - 1;
                              _cacheController.lengthDressList =
                                  await _cacheController.lengthDressList + 1;

                              Get.back();
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.save),
                              Text('Kaydet'),
                            ],
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () async {
                            {
                              _cacheController.result = await Get.defaultDialog(
                                  title: 'Emin misin?',
                                  content: ElevatedButton(
                                      onPressed: (() {
                                        _cacheController.deleteDress(index);
                                        Get.back<bool>(result: true);
                                      }),
                                      child: Text('Onayla')));

                              if (_cacheController.result) {
                                _cacheController.result = false;
                                Get.back();
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_outlined),
                              Text('Sil'),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

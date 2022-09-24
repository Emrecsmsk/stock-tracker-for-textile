import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tekstilstok/controller/cache/cache.dart';
import 'package:tekstilstok/view_model/dress_model.dart';

class AddDress extends StatefulWidget {
  const AddDress({Key? key}) : super(key: key);

  @override
  State<AddDress> createState() => _AddDressState();
}

class _AddDressState extends State<AddDress> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cacheController = Get.put(CacheDress());
  }

  late CacheDress _cacheController;
  TextEditingController? _idController = TextEditingController();
  TextEditingController? _pieceController = TextEditingController();
  TextEditingController? _priceController = TextEditingController();
  TextEditingController? _dateController = TextEditingController();

  final GlobalKey<FormState> _formAddKey = GlobalKey();
  final String addDress = 'Elbise Ekle';
  final String errorValidation = 'En az bir karakter giriniz';
  final String modelNumber = 'Model Numarası';
  final String piece = 'Adet';
  final String price = 'Fiyat';
  final String date = 'Tarih';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addDress),
      ),
      body: _form(context),
    );
  }

  Form _form(BuildContext context) {
    return Form(
        key: _formAddKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Expanded(
                      flex: 6, child: Lottie.asset('assets/lottie/dress.json'))
                  : SizedBox.shrink(),
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: modelNumber),
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  validator: (String? data) =>
                      ((data?.length ?? 0) >= 1) ? null : errorValidation,
                ),
              ),
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: piece),
                  controller: _pieceController,
                  keyboardType: TextInputType.number,
                  validator: (String? data) =>
                      ((data?.length ?? 0) >= 1) ? null : errorValidation,
                ),
              ),
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: price),
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  validator: (String? data) =>
                      ((data?.length ?? 0) >= 1) ? null : errorValidation,
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: date),
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  validator: (String? data) =>
                      ((data?.length ?? 0) >= 1) ? null : errorValidation,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formAddKey.currentState?.validate() ?? false) {
                      _cacheController.addDress(DressModel(
                          id: _idController!.text,
                          piece: int.parse(_pieceController!.text),
                          price: int.parse(_priceController!.text),
                          date: _dateController!.text));
                      Get.back();
                    }
                  },
                  child: Text('Kaydet'))
            ],
          ),
        ));
  }
}

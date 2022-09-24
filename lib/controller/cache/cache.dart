import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../view_model/dress_model.dart';
import '../../view_model/dress_money_model.dart';

class CacheDress extends GetxController {
  final box = GetStorage();
  var _counter = 0.obs;
  var _dressList = <DressModel>[].obs;
  var _dressMoney = <DressMoney>[].obs;
  var _lengthDressList = 0.obs;
  var _totalMoney = 0.obs;
  var _totalReceived = 0.obs;
  var _totalRemainder = 0.obs;
  var _green = 0.obs;
  var _result = false.obs;

  get result => _result.value;
  set result(data) => _result.value = data;

  get totalMoney => _totalMoney.value;
  set totalMoney(data) => _totalMoney.value = data;

  get totalReceived => _totalReceived.value;
  set totalReceived(data) => _totalReceived.value = data;

  get totalRemainder => _totalRemainder.value;
  set totalRemainder(data) => _totalRemainder.value = data;

  get green => _green.value;
  set green(data) => _green.value = data;

  get lengthDressList => _lengthDressList.value;
  set lengthDressList(data) => _lengthDressList.value = data;

  get counter => _counter.value;
  set counter(data) => _counter.value = data;

  get dressList => _dressList.value;
  void addList(DressModel item) {
    _dressList.add(item);
  }

  get dressMoney => _dressMoney.value;
  void addMoney(DressMoney item) {
    _dressMoney.add(item);
  }

//reset for rebuilding list
  void reset() {
    _dressList.clear();
    _dressMoney.clear();
  }

//check local storage for dress
  void dressListCheck() {
    totalMoney = 0;
    totalReceived = 0;
    totalRemainder = 0;
    counter = box.read('counter') ?? 0;
    lengthDressList = counter;
    counter = counter - 1;
    for (var i = counter; i >= 0; i--) {
      if (box.read('$i.id') == null) {
        lengthDressList = lengthDressList - 1;
        continue;
      }
      addList(DressModel(
        id: box.read('$i.id') == null ? '' : box.read('$i.id'),
        piece: box.read('$i.piece') == null ? 00 : box.read('$i.piece'),
        price: box.read('$i.price') == null ? 00 : box.read('$i.price'),
        date: box.read('$i.date') == null ? '' : box.read('$i.date'),
      ));
    }
    for (var i = counter; i >= 0; i--) {
      if (box.read('$i.id') == null) {
        continue;
      }
      addMoney(DressMoney(
          total:
              box.read('$i.totalMoney') == null ? 1 : box.read('$i.totalMoney'),
          remainder:
              box.read('$i.remainder') == null ? 1 : box.read('$i.remainder'),
          received:
              box.read('$i.received') == null ? 1 : box.read('$i.received'),
          green: box.read('$i.green') == null ? 1 : box.read('$i.green')));
      totalMoney = totalMoney + (box.read('$i.totalMoney') ?? 0);
      totalReceived = totalReceived + (box.read('$i.received') ?? 0);
      totalRemainder = totalRemainder + (box.read('$i.remainder') ?? 0);
    }

    counter = counter + 1;
  }

//add the dress to local storage
  void addDress(DressModel dressModel) {
    box.write('$counter.id', dressModel.id);
    box.write('$counter.piece', dressModel.piece);
    box.write('$counter.price', dressModel.price);
    box.write('$counter.date', dressModel.date);
    box.write('$counter.totalMoney', dressModel.price * dressModel.piece);
    box.write('$counter.received', 0);
    box.write('$counter.remainder', dressModel.price * dressModel.piece);
    box.write('$counter.green', 0.0);

    counter = counter + 1;
    box.write('counter', counter);
    reset();
    dressListCheck();
  }

//add the received money to local storage
  addModelMoney(i, money) {
    box.write('${(counter - 1 - i)}.received',
        (box.read('${(counter - 1 - i)}.received') + money));
    box.write(
        '${(counter - 1 - i)}.remainder',
        (box.read('${(counter - 1 - i)}.totalMoney')) -
            (box.read('${(counter - 1 - i)}.received')));
    box.write(
        '${counter - 1 - i}.green',
        (box.read('${(counter - 1 - i)}.received')) /
            (box.read('${(counter - 1 - i)}.totalMoney')));

    reset();
    dressListCheck();
  }

// delete dress from local storage
  void deleteDress(index) {
    box.remove('${counter - 1 - index}.id');
    box.remove('${counter - 1 - index}.piece');
    box.remove('${counter - 1 - index}.price');
    box.remove('${counter - 1 - index}.date');
    box.remove('${counter - 1 - index}.totalMoney');
    box.remove('${counter - 1 - index}.received');
    box.remove('${counter - 1 - index}.remainder');
    box.remove('${counter - 1 - index}.green');

    for (var i = counter - index; counter > i; i++) {
      box.write('${i - 1}.id', box.read('$i.id'));
      box.write('${i - 1}.piece', box.read('$i.piece'));
      box.write('${i - 1}.price', box.read('$i.price'));
      box.write('${i - 1}.date', box.read('$i.date'));
      box.write('${i - 1}.totalMoney', box.read('$i.totalMoney'));
      box.write('${i - 1}.received', box.read('$i.received'));
      box.write('${i - 1}.remainder', box.read('$i.remainder'));
      box.write('${i - 1}.green', box.read('$i.green'));
      box.remove('$i.id');
      box.remove('$i.piece');
      box.remove('$i.price');
      box.remove('$i.date');
      box.remove('$i.totalMoney');
      box.remove('$i.received');
      box.remove('$i.remainder');
      box.remove('$i.green');
    }

    counter = counter - 1;
    box.write('counter', counter);
    reset();
    dressListCheck();
  }
}

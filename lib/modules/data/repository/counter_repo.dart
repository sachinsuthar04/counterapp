import 'dart:math';

import 'package:hive/hive.dart';

class CounterRepository {
  final Random random = Random();
  late final hiveBox = Hive.box('Counter');

  getRandomNumber() {
    int randomNumber = random.nextInt(59);
    return randomNumber;
  }

  getCounter() async {
    final value = await hiveBox.get('success');
    return value;
  }


  setCounter() async {
    dynamic value = await hiveBox.get('success');
    await hiveBox.put('success', ((value ?? 0) + 1));
    return (value ?? 0) + 1;
  }
  setFailCounter() async {
    dynamic value = await hiveBox.get('fail');
    await hiveBox.put('fail', ((value ?? 0) + 1));
    return (value ?? 0) + 1;
  }
  getCounterFail() async {
    final value = await hiveBox.get('fail');
    return value;
  }

  setPenaltyCounter() async {
    dynamic value = await hiveBox.get('Penalty');
    await hiveBox.put('Penalty', ((value ?? 0) + 1));
    return (value ?? 0) + 1;
  }
  getCounterPenalty() async {
    final value = await hiveBox.get('Penalty');
    return value;
  }
  resetCounter() async {
    await hiveBox.put('success', 0);
    await hiveBox.put('fail', 0);
    await hiveBox.put('Penalty', 0);
    return 0;
  }
}

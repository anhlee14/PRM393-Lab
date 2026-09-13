import 'dart:async';

//Future.delayed() to simulate loading.
Future<String> fetchRemoteData() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Remote data fetched successfully.';
}

Stream<int> numberStream(int limit) async* {
  for (int i = 1; i <= limit; i++) {
    await Future.delayed(const Duration(milliseconds: 400));
    yield i;
  }
}

void main() async {
  print('--- Exercise 5 – Async, Future, Null Safety & Streams ---');

  //null-safety operators (?, ??, !).
  String? username;
  print('Safe navigation (?): ${username?.length}');

  String finalName = username ?? 'Default Guest';
  print('Display Name: $finalName');

  username = 'Administrator';
  print('Null assertion (!): ${username!.toUpperCase()}');

  print('Loading data...');
  String result = await fetchRemoteData();
  print('Result: $result');

  // listen to values
  print('Listening to stream values:');
  await for (int number in numberStream(5)) {
    print('Stream emitted: $number');
  }
}
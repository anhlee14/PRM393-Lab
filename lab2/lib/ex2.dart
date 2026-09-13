void main() {
  print('--- Exercise 2 – Collections & Operators ---');

  //1. Create a List of integers
  List<int> numbers = [10, 20, 30];
  numbers.add(36);
  print('List of numbers: $numbers');

  //2.	Use arithmetic & comparison operators.
  int sum = numbers[0] + numbers[1];
  int sub = numbers[3] - numbers[0];
  print('Sum of index 0 and 1: $sum');
  print('Sub of index 3 and 0: $sub');
  bool isConditionMet = numbers.last > 25 && numbers.first == 10;
  String evaluation = isConditionMet ? 'Condition Met' : 'Condition Failed';
  print('Evaluation status: $evaluation');

  //3.	Create a Set (unique values) and a Map (key-value).
  Set<String> techStack = {'Flutter', 'Dart', 'Mobile'};
  techStack.add('Dart');
  techStack.remove('Mobile');
  print('Tech Stack Set: $techStack');
  Map<String, dynamic> course = {
    'code': 'PRM393',
    'credits': 3,
  };
  course['semester'] = 'Fall 2026';
  print('Course Map: $course');
  print('Course Code: ${course['code']}');


}
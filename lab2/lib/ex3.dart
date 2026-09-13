double calculateArea(double width, double height) {
  return width * height;
}
String formatMessage(String msg) => '$msg';

void main() {
  print('--- Exercise 3 – Control Flow & Functions ---');

  //1.	Write an if/else block to check score.
  double score = 0;
  if (score >= 9.0) {
    print('Grade: Excellent');
  } else if (score >= 8.0) {
    print('Grade: Good');
  } else {
    print('Grade: Average');
  }

  //2.	Write a switch case for day of week.
  int dayOfWeek = 5;
  switch (dayOfWeek) {
    case 1:
      print('Day: Monday');
      break;
    case 2:
      print('Day: Thursday');
    case 3:
      print('Day: Wednesday');
      break;
    case 4:
      print('Day: Thursday');
      break;
    case 5:
      print('Day: Friday');
      break;
    case 6:
      print('Day: Saturday');
      break;
    case 7:
      print('Day: Sunday');
      break;
    default:
      print('Day: Invalid');
  }

  //3.	Loop through a collection using for, for-in, and forEach().
  List<String> devices = ['Iphone', 'Samsung', 'Ipad', 'Tablet'];

  print('For loop:');
  for (int i = 0; i < devices.length; i++) {
    print(' - Device $i: ${devices[i]}');
  }

  print('For-in loop:');
  for (var device in devices) {
    print(' - Item: $device');
  }

  print('forEach():');
  devices.forEach((item) => print(' - $item'));

  //4. Function
  print('Calculated Area: ${calculateArea(6, 8)}');
  print('Formatted Text: ${formatMessage("Dart Control Flow")}');
}
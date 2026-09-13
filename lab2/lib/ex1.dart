
void main() {
  print('--- Exercise 1 – Basic Syntax & Data Types ---');

  //Declare variables using: int, double, String, bool
  int studentAge = 22;
  double GPA = 3.7;
  String studentName = 'DucAnh';
  bool isEnrolled = true;

  // Print result using string interpolation (&var, ${eexpr})
  print('Student Name: $studentName');
  print('Age: $studentAge (year of birth: ${2026 - studentAge})');
  print('GPA: $GPA');
  print('Active Enrollment: $isEnrolled');
}
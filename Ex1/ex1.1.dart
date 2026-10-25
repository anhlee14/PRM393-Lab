class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);

  void startEngine() {
    print("Khởi động phương tiện..");
  }
}

class Car extends Vehicle {
  bool isElectric;

  Car(String brand, int year, this.isElectric) : super(brand,year);

  Car.tesla(int year) : isElectric = true, super('Tesla', year);
  
  @override
  void startEngine() {
    if (isElectric) {
      print("$brand ($year): Xe chạy bằng điện, không có tiếng ồn");
    } else {
      print("$brand ($year): Đang khởi động động cơ xăng, brummmmmmmmm");
    }
  }
}

void main() {
  print("EX1.1");

  Car hondaCar = Car("Honda civic", 2025, false);
  hondaCar.startEngine();

  Car teslaCar = Car.tesla(2024);
  teslaCar.startEngine();
}

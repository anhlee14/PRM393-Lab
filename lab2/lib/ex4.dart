class Car {
  String brand;
  Car(this.brand);
  Car.custom(this.brand);

  void drive() {
    print('$brand is driving using a standard engine.');
  }
}

class ElectricCar extends Car {
  int batteryCapacity;

  ElectricCar(super.brand, this.batteryCapacity);

  @override
  void drive() {
    print('$brand is running on electric power ($batteryCapacity% battery).');
  }
}

void main() {
  print('--- Exercise 4 – Intro to OOP ---');

  Car standardCar = Car('Toyota');
  standardCar.drive();

  Car customCar = Car.custom('Honda');
  customCar.drive();

  ElectricCar ev = ElectricCar('Tesla Model 3', 95);
  ev.drive();
}

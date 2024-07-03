//ระบบสามารถจัดการเมนูอาหาร การสั่งอาหาร และการจัดการโต๊ะได้
import 'dart:io';

class MenuItem {
  late String name; //ชื่ออาหาร
  late double price;
  late String category; //หมวดหมู่อาหาร: อาหารคาว, อาหารหวาน, เครื่องดื่ม

  MenuItem(this.name, this.price, this.category);
}

class Order {
  String orderId; //หมายเลขการสั่งอาหาร
  var tableNumber; //หมายเลขโต๊ะ
  List<MenuItem> items = []; //รายการอาหารที่สั่ง ดึงจาก class MenuItem
  // bool isCompleted = false; //สถานะการสั่งอาหาร: true ถ้าเสร็จแล้ว, false ถ้ายังไม่เสร็จ)

  Order(this.orderId, this.tableNumber);

  void addItem(MenuItem item) {
    items.add(item); //เพิ่มรายการอาหารในคำสั่ง
  }

  double getTotalPrice() {
    return items.fold(0, (sum, item) => sum + item.price);
  }

  String getOrderSummary() {
    var summary = StringBuffer();
    summary.writeln('Order ID: $orderId, Table Number: $tableNumber');
    summary.writeln('Items Ordered:');
    items.forEach((item) {
      summary.writeln('${item.name} - ${item.price}');
    });
    summary.writeln('Total Price: ${getTotalPrice()}');
    return summary.toString();
  }
}

class Restaurant {
  List<MenuItem> menu = []; //เมนูอาหาร ดึงจาก class MenuItem
  List<Order> orders = []; //รายการสั่งอาหาร
  List<bool> tables = []; //สถานะของโต๊ะในร้านอาหาร

  Restaurant(int numberOfTables) {
    tables = List.filled(
        numberOfTables, true); // True = โต๊ะว่าง, False = โต๊ะไม่ว่าง
  }

  void addMenuItem(MenuItem item) {
    menu.add(item); //เพิ่มรายการอาหารในเมนู
  }

  MenuItem? getMenuItem(String name) {
    // ค้นหารายการอาหารตามชื่อ
    for (var item in menu) {
      if (item.name == name) {
        return item;
      }
    }
    return null; // หากไม่พบรายการอาหาร
  }

  void placeOrder(Order order) {
    orders.add(order); //สร้างคำสั่งอาหาร
    tables[int.parse(order.tableNumber) - 1] = false; // สถานะโต๊ะว่าไม่ว่าง
  }

  Order? getOrder(String orderId) {
    // ค้นหาคำสั่งอาหารตามหมายเลขการสั่ง
    for (var order in orders) {
      if (order.orderId == orderId) {
        return order;
      }
    }
    return null; // หากไม่พบคำสั่งอาหาร
  }

  void removeMenuItem(MenuItem item) {
    menu.remove(item); //ลบรายการอาหารจากเมนู
  }

  void updateMenuItem(
      String name, String newName, double newPrice, String newCategory) {
    var item = getMenuItem(name);
    if (item != null) {
      item.name = newName;
      item.price = newPrice;
      item.category = newCategory;
    }
  }

  void updateOrder(String orderId, int newTableNumber) {
    var order = getOrder(orderId);
    if (order != null) {
      order.tableNumber = newTableNumber.toString();
    }
  }

  List<Order> searchOrderByTableNumber(String tableNumber) {
    return orders.where((order) => order.tableNumber == tableNumber).toList();
  }
}

//-----------------------------------------------------------------------

void main() {
  // สร้างออบเจ็กต์ MenuItem
  var menuItem1 = MenuItem('Cake', 60, 'Dessert');
  var menuItem2 = MenuItem('Pudding', 25, 'Dessert');
  var menuItem3 = MenuItem('Steak', 80, 'Main course');
  var menuItem4 = MenuItem('Salad', 70, 'Main course');
  var menuItem5 = MenuItem('Milk', 16, 'Beverage');
  var menuItem6 = MenuItem('Coffee', 35, 'Beverage');

  // สร้างออบเจ็กต์ Order
  var order1 = Order('0001', '1');
  order1.addItem(menuItem1);
  order1.addItem(menuItem1);
  var order2 = Order('0002', '2');
  order2.addItem(menuItem3);
  order2.addItem(menuItem6);

  // สร้างออบเจ็กต์ Restaurant
  var restaurant = Restaurant(10); //ร้านมีแค่โต๊ะ 10 ตัว
  restaurant.addMenuItem(menuItem1);
  restaurant.addMenuItem(menuItem2);
  restaurant.addMenuItem(menuItem3);
  restaurant.addMenuItem(menuItem4);
  restaurant.addMenuItem(menuItem5);
  restaurant.addMenuItem(menuItem6);

  // เพิ่ม Order ลงใน Restaurant
  restaurant.placeOrder(order1);
  restaurant.placeOrder(order2);

  // สร้างระบบ CRUD ของ MenuItem, Order  และ Restaurant
  // สร้างระบบ เมนู
  while (true) {
    print('----------[ Restaurant ]----------');
    print('1 Menu Item'); //แสดงเมนูที่มีในร้าน
    print('2 Order'); //สั่งอาหาร
    print('3 Search'); //ค้นหา
    print('4 Edit'); //แก้ไขข้อมูล
    print('5 Delete'); //ลบข้อมูล
    print('0 Exit'); //ออกจากระบบ
    stdout.write('Please enter your choice: '); //พิมพ์เลข
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        showMenu(restaurant);
        break;

      case '2':
        print('----------[ Order ]----------');
        manageOrder(restaurant);
        break;

      case '3':
        searchItem(restaurant);
        break;

      case '4':
        editItem(restaurant);
        break;

      case '5':
        delete(restaurant);
        break;

      case '0':
        print('Exiting program.');
        return;

      default:
        print('Invalid choice, please try again.');
    }
  }
}

//--------------------------------------------------

void showMenu(Restaurant restaurant) {
  print('----------[ Menu ]----------');
  restaurant.menu.forEach((item) {
    print('${item.name} - ${item.price} - ${item.category}');
  });
}

void manageOrder(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter table number (or type 000 to finish): ');
    var tableNumberInput = stdin.readLineSync()!;
    if (tableNumberInput == '000') return;

    var tableNumber = int.tryParse(tableNumberInput);
    if (tableNumber == null ||
        tableNumber < 1 ||
        tableNumber > restaurant.tables.length) {
      print('Invalid table number. Please try again.');
      continue;
    }

    if (!restaurant.tables[tableNumber - 1]) {
      print('Table $tableNumber is currently occupied. Cannot place order.');
      continue;
    }

    var orderId = (restaurant.orders.length + 1).toString().padLeft(4, '0');
    var order = Order(orderId, tableNumberInput);

    while (true) {
      stdout.write('Enter menu item name (or type 000 to finish): ');
      var itemName = stdin.readLineSync()!;
      if (itemName == '000') {
        // Display order summary and confirmation
        print(order.getOrderSummary());
        stdout.write('Confirm order (Y/N): ');
        var confirm = stdin.readLineSync();
        if (confirm?.toUpperCase() == 'Y') {
          restaurant.placeOrder(order);
          print('Order placed successfully.');
        } else {
          print('Order canceled.');
        }
        break;
      }

      var menuItem = restaurant.getMenuItem(itemName);
      if (menuItem != null) {
        stdout.write('Enter quantity: ');
        var quantity = int.tryParse(stdin.readLineSync()!);
        if (quantity != null && quantity > 0) {
          for (var i = 0; i < quantity; i++) {
            order.addItem(menuItem);
          }
        } else {
          print('Invalid quantity. Please enter a positive number.');
        }
      } else {
        print('Menu item not found.');
      }
    }
  }
}

void searchItem(Restaurant restaurant) {
  while (true) {
    print('----------[ Search ]----------');
    print('1 Menu Item'); //ดูเมนูที่มีในร้าน
    print('2 Order'); //orderที่มีในร้าน
    print('3 Table'); //โต๊ะในร้าน
    print('0 Back'); //กลับไปหน้าหลัก
    stdout.write('Please enter your choice: ');
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('--------[ Search Menu Item ]--------');
        searchMenuItem(restaurant);
        break;

      case '2':
        print('----------[ Search Order ]----------');
        searchOrder(restaurant);
        break;

      case '3':
        print('----------[ Search Table ]----------');
        searchTable(restaurant);
        break;

      case '0':
        return;

      default:
        print('Invalid choice, please try again.');
    }
  }
}

void searchMenuItem(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter menu item name (or type 000 to finish): ');
    var name = stdin.readLineSync()!;
    if (name == '000') return;

    var menuItem = restaurant.getMenuItem(name);
    if (menuItem != null) {
      print(
          'Found Menu Item: ${menuItem.name}, ${menuItem.price}, ${menuItem.category}');
    } else {
      print('Menu item not found.');
    }
  }
}

void searchOrder(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter order ID (or type 000 to finish): ');
    var orderId = stdin.readLineSync()!;
    if (orderId == '000') return;
    var order = restaurant.getOrder(orderId);
    if (order != null) {
      print('Order Found:');
      print(order.getOrderSummary());
    } else {
      print('Order not found.');
    }
  }
}

void searchTable(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter table number (or type 000 to finish): ');
    var input = stdin.readLineSync()!;
    if (input == '000') return;

    var tableNumber = int.tryParse(input);
    if (tableNumber != null) {
      if (tableNumber >= 1 && tableNumber <= restaurant.tables.length) {
        if (restaurant.tables[tableNumber - 1]) {
          print('Table $tableNumber is available.');
        } else {
          print('Table $tableNumber is occupied.');
        }
      } else {
        print('Invalid table number. Please try again.');
      }
    } else {
      print('Invalid input. Please enter a number.');
    }
  }
}

void editItem(Restaurant restaurant) {
  while (true) {
    print('-----------[ Edit ]-----------');
    print('1 Menu Item'); //แก้ไขเมนูในร้าน
    print('2 Order and Table'); //แก้ไขข้อมูล order และโต๊ะ
    print('0 Back'); //กลับไปหน้าหลัก
    stdout.write('Please enter your choice: ');
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('--------[ Edit Menu Item ]--------');
        editMenuItem(restaurant);
        break;

      case '2':
        print('--------[ Edit Order ]--------');
        editOrder(restaurant);
        break;

      case '0':
        return;

      default:
        print('Invalid choice, please try again.');
    }
  }
}

void delete(Restaurant restaurant) {
  while (true) {
    print('-----------[ Delete ]-----------');
    print('1 Menu Item'); //ลบเมนูในร้าน
    print('2 Order'); //ลบ order
    print('0 Back'); //กลับไปหน้าหลัก
    stdout.write('Please enter your choice: ');
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('--------[ Delete Menu Item ]--------');
        deleteMenuItem(restaurant);
        break;

      case '2':
        print('----------[ Delete Order ]----------');
        deleteOrder(restaurant);
        break;

      case '0':
        return;

      default:
        print('Invalid choice, please try again.');
    }
  }
}

void deleteMenuItem(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter menu item name to delete (or type 000 to finish): ');
    var name = stdin.readLineSync()!;
    if (name == '000') return;

    var menuItem = restaurant.getMenuItem(name);
    if (menuItem != null) {
      restaurant.removeMenuItem(menuItem);
      print('Menu item deleted successfully.');
    } else {
      print('Menu item not found.');
    }
  }
}

void deleteOrder(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter order ID to delete (or type 000 to finish): ');
    var orderId = stdin.readLineSync()!;
    if (orderId == '000') return;

    var order = restaurant.getOrder(orderId);
    if (order != null) {
      restaurant.orders.remove(order);
      restaurant.tables[int.parse(order.tableNumber) - 1] = true; //ตั้งสถานะโต๊ะว่าว่าง
      print('Order deleted successfully.');
    } else {
      print('Order not found.');
    }
  }
}

bool editMenuItem(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter menu item name to edit (or type 000 to finish): ');
    var name = stdin.readLineSync()!;
    if (name == '000') return true;

    var menuItem = restaurant.getMenuItem(name);
    if (menuItem != null) {
      print(
          'Editing Menu Item: ${menuItem.name}, ${menuItem.price}, ${menuItem.category}');
      stdout.write('New Name: ');
      var newName = stdin.readLineSync()!;
      stdout.write('New Price: ');
      var newPrice = double.parse(stdin.readLineSync()!);
      stdout.write('New Category: ');
      var newCategory = stdin.readLineSync()!;
      stdout.write('Press Y to confirm or C to cancel: ');
      var confirm = stdin.readLineSync();
      if (confirm?.toUpperCase() == 'Y') {
        restaurant.updateMenuItem(name, newName, newPrice, newCategory);
        print('Menu item updated successfully.');
      } else {
        print('Update canceled.');
      }
    } else {
      print('Menu item not found.');
    }
  }
}

bool editOrder(Restaurant restaurant) {
  while (true) {
    stdout.write('Enter order ID to edit (or type 000 to finish): ');
    var orderId = stdin.readLineSync()!;
    if (orderId == '000') return true;

    var order = restaurant.getOrder(orderId);
    if (order != null) {
      print(
          'Editing Order: ${order.orderId}, Table: ${order.tableNumber}, Completed: ${order.items.length}');
      stdout.write('New Table Number: ');
      var newTableNumber = int.parse(stdin.readLineSync()!);
      if (newTableNumber >= 1 && newTableNumber <= restaurant.tables.length) {
        if (!restaurant.tables[newTableNumber - 1]) {
          print('Table $newTableNumber is currently occupied. Cannot move order.');
        } else {
          restaurant.tables[int.parse(order.tableNumber) - 1] = true; // ตั้งโต๊ะเดิมว่าว่าง
          restaurant.updateOrder(orderId, newTableNumber);
          restaurant.tables[newTableNumber - 1] = false; // ตั้งโต๊ะใหม่ว่าไม่ว่าง
          print('Order updated successfully.');
        }
      } else {
        print('Invalid table number. Please try again.');
      }
    } else {
      print('Order not found.');
    }
  }
}

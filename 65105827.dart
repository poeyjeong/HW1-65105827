//ระบบสามารถจัดการเมนูอาหาร การสั่งอาหาร และการจัดการโต๊ะได้
import 'dart:io';

class MenuItem {
  late String name; //ชื่ออาหาร
  late double price;
  late String category; //หมวดหมู่อาหาร: อาหารคาว, อาหารหวาน, เครื่องดื่ม

  MenuItem(this.name, this.price, this.category);
}

class Order {
  var orderId; //หมายเลขการสั่งอาหาร
  var tableNumber; //หมายเลขโต๊ะ
  List<MenuItem> items = []; //รายการอาหารที่สั่ง ดึงจาก class MenuItem
  bool isCompleted =
      false; //สถานะการสั่งอาหาร: true ถ้าเสร็จแล้ว, false ถ้ายังไม่เสร็จ)

  Order(this.orderId, this.tableNumber);

  void addItem(MenuItem item) {
    items.add(item); //เพิ่มรายการอาหารในคำสั่ง
  }

  void removeItem(MenuItem item) {
    items.remove(item); //ลบรายการอาหารจากคำสั่ง
  }

  void completeOrder() {
    isCompleted = true; //ทำให้คำสั่งเสร็จสิ้น
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

  void removeMenuItem(MenuItem item) {
    menu.remove(item); //ลบรายการอาหารจากเมนู
  }

  void placeOrder(Order order) {
    orders.add(order); //สร้างคำสั่งอาหาร
    tables[int.parse(order.tableNumber) - 1] = false; // สถานะโต๊ะว่าไม่ว่าง
  }

  void completeOrder(String orderId) {
    //ทำให้คำสั่งเสร็จสิ้น
    var order = getOrder(orderId);
    if (order != null) {
      order.completeOrder();
      tables[int.parse(order.tableNumber) - 1] = true; // สถานะโต๊ะว่าว่าง
    }
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

  Order? getOrder(String orderId) {
    // ค้นหาคำสั่งอาหารตามหมายเลขการสั่ง
    for (var order in orders) {
      if (order.orderId == orderId) {
        return order;
      }
    }
    return null; // หากไม่พบคำสั่งอาหาร
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
      tables[int.parse(order.tableNumber) - 1] =
          true; // ตั้งสถานะโต๊ะเดิมว่าว่าง
      order.tableNumber = newTableNumber.toString();
      tables[newTableNumber - 1] = false; // ตั้งสถานะโต๊ะใหม่ว่าไม่ว่าง
    }
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
  var restaurant = Restaurant(10);
  restaurant.addMenuItem(menuItem1);
  restaurant.addMenuItem(menuItem2);
  restaurant.addMenuItem(menuItem3);
  restaurant.addMenuItem(menuItem4);
  restaurant.addMenuItem(menuItem5);
  restaurant.addMenuItem(menuItem6);

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

    if (choice == null || choice.trim().isEmpty) {
      print('Invalid input detected. Please try again.');
      continue;
    }

    switch (choice) {
      case '1':
        showMenu(restaurant);
        break;

      case '2':
        manageOrder(restaurant);
        break;

      case '3':
        searchItem(restaurant);
        break;

      case '4':
        editItem(restaurant);
        break;

      case '5':
        deleteItem(restaurant);
        break;

      case '0':
        break;

      default:
        print('Invalid choice, please try again.');
    }
  }
}

//--------------------------------------------------

void showMenu(Restaurant restaurant) {
  print('----------[ Menu ]----------');
  for (var item in restaurant.menu) {
    print('${item.name} - ${item.price} - ${item.category}');
  }
}

void manageOrder(Restaurant restaurant) {
  stdout.write('Enter table number: ');
  var tableNumber = stdin.readLineSync()!;
  var order = Order((restaurant.orders.length + 1).toString(), tableNumber);

  while (true) {
    stdout.write('Enter menu item name (or type 000 to finish): ');
    var itemName = stdin.readLineSync()!;
    if (itemName == '000') break;

    var menuItem = restaurant.getMenuItem(itemName);
    if (menuItem != null) {
      stdout.write('Enter quantity: ');
      var quantity = int.parse(stdin.readLineSync()!);
      for (var i = 0; i < quantity; i++) {
        order.addItem(menuItem);
      }
    } else {
      print('Menu item not found.');
    }
  }

  restaurant.placeOrder(order);
  print('Order placed successfully.');
}

void searchItem(Restaurant restaurant) {
  print('----------[ Search ]----------');
  print('1 Menu Item'); //ดูเมนูที่มีในร้าน
  print('2 Order'); //orderที่มีในร้าน
  print('3 Table'); //โต๊ะในร้าน
  print('0 Back'); //กลับไปหน้าหลัก
  stdout.write('Please enter your choice: ');
  var choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      stdout.write('Enter menu item name: ');
      var name = stdin.readLineSync()!;
      var menuItem = restaurant.getMenuItem(name);
      if (menuItem != null) {
        print(
            'Found Menu Item: ${menuItem.name}, ${menuItem.price}, ${menuItem.category}');
      } else {
        print('Menu item not found.');
      }
      break;

    case '2':
      stdout.write('Enter order ID: ');
      var orderId = stdin.readLineSync()!;
      var order = restaurant.getOrder(orderId);
      if (order != null) {
        print(
            'Found Order: ${order.orderId}, Table: ${order.tableNumber}, Completed: ${order.isCompleted}');
      } else {
        print('Order not found.');
      }
      break;

    case '3':
      stdout.write('Enter table number: ');
      var tableNumber = int.parse(stdin.readLineSync()!);
      if (restaurant.tables[tableNumber - 1]) {
        print('Table $tableNumber is available.');
      } else {
        print('Table $tableNumber is occupied.');
      }
      break;

    case '0':
      return;

    default:
      print('Invalid choice, please try again.');
  }
}

void editItem(Restaurant restaurant) {
  print('-----------[ Edit ]-----------');
  print('1 Menu Item'); //แก้ไขเมนูในร้าน
  print('2 Order and Table'); //แก้ไขข้อมูล order และโต๊ะ
  print('0 Back'); //กลับไปหน้าหลัก
  stdout.write('Please enter your choice: ');
  var choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      editMenuItem(restaurant);
      break;

    case '2':
      editOrder(restaurant);
      break;

    case '0':
      return;

    default:
      print('Invalid choice, please try again.');
  }
}

void deleteItem(Restaurant restaurant) {
  print('-----------[ Delete ]-----------');
  print('1 Menu Item'); //ลบเมนูในร้าน
  print('2 Order'); //ลบ order
  print('0 Back'); //กลับไปหน้าหลัก
  stdout.write('Please enter your choice: ');
  var choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      deleteMenuItem(restaurant);
      break;

    case '2':
      deleteOrder(restaurant);
      break;

    case '0':
      return;

    default:
      print('Invalid choice, please try again.');
  }
}

void deleteMenuItem(Restaurant restaurant) {
  stdout.write('Enter menu item name to delete: ');
  var name = stdin.readLineSync()!;
  var menuItem = restaurant.getMenuItem(name);
  if (menuItem != null) {
    restaurant.removeMenuItem(menuItem);
    print('Menu item deleted successfully.');
  } else {
    print('Menu item not found.');
  }
}

void deleteOrder(Restaurant restaurant) {
  stdout.write('Enter order ID to delete: ');
  var orderId = stdin.readLineSync()!;
  var order = restaurant.getOrder(orderId);
  if (order != null) {
    restaurant.orders.remove(order);
    restaurant.tables[int.parse(order.tableNumber) - 1] =
        true; //ตั้งสถานะโต๊ะว่าว่าง
    print('Order deleted successfully.');
  } else {
    print('Order not found.');
  }
}

void editMenuItem(Restaurant restaurant) {
  stdout.write('Enter menu item name to edit: ');
  var name = stdin.readLineSync()!;
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

    restaurant.updateMenuItem(name, newName, newPrice, newCategory);
    print('Menu item updated successfully.');
  } else {
    print('Menu item not found.');
  }
}

void editOrder(Restaurant restaurant) {
  //แก้ไขรายละเอียดข้อมูล order และโต๊ะ
  stdout.write('Enter order ID to edit: ');
  var orderId = stdin.readLineSync()!;
  var order = restaurant.getOrder(orderId);
  if (order != null) {
    print(
        'Editing Order: ${order.orderId}, Table: ${order.tableNumber}, Completed: ${order.isCompleted}');
    stdout.write('New Table Number: ');
    var newTableNumber = int.parse(stdin.readLineSync()!);
    restaurant.updateOrder(orderId, newTableNumber);
    print('Order updated successfully.');
  } else {
    print('Order not found.');
  }
}

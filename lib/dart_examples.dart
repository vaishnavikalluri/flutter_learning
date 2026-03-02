// Dart Language Fundamentals Examples
// Demonstrates key Dart concepts used in Flutter development

// 1. CLASSES & OBJECTS
// Everything in Dart is an object, including numbers, functions, and null
class Student {
  // Properties with type declarations
  String name;
  int age;
  
  // Constructor using shorthand syntax
  Student(this.name, this.age);
  
  // Method with string interpolation
  void introduce() {
    print('Hi, I\'m $name and I\'m $age years old.');
  }
  
  // Method with return value
  bool isAdult() {
    return age >= 18;
  }
}

// 2. NULL SAFETY
// Dart has built-in null safety to prevent null reference errors
class Profile {
  String username;          // Non-nullable - must have a value
  String? email;            // Nullable - can be null
  int? age;
  
  Profile(this.username, {this.email, this.age});
  
  void displayInfo() {
    print('Username: $username');
    // Use null-aware operator (??) to provide default value
    print('Email: ${email ?? "Not provided"}');
    // Use null-aware access operator (?.)
    print('Age: ${age?.toString() ?? "Not specified"}');
  }
}

// 3. ASYNC/AWAIT
// Essential for handling asynchronous operations like API calls or Firebase
Future<String> fetchUserData() async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));
  return 'User data fetched successfully!';
}

Future<void> demonstrateAsync() async {
  print('Fetching data...');
  String result = await fetchUserData();
  print(result);
}

// 4. COLLECTIONS
void demonstrateCollections() {
  // List (Array)
  List<String> fruits = ['Apple', 'Banana', 'Orange'];
  fruits.add('Mango');
  print('Fruits: $fruits');
  
  // Map (Key-Value pairs)
  Map<String, int> scores = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92,
  };
  scores['David'] = 88;
  print('Scores: $scores');
  
  // Set (Unique values)
  Set<int> uniqueNumbers = {1, 2, 3, 4}; // Sets only store unique values
  uniqueNumbers.add(3); // Adding duplicate has no effect
  print('Unique numbers: $uniqueNumbers');
}

// 5. TYPE INFERENCE & VAR
void demonstrateTypeInference() {
  // Dart can infer types automatically
  var name = 'Flutter';        // Inferred as String
  var version = 3.19;          // Inferred as double
  var isStable = true;         // Inferred as bool
  var widgets = ['Text', 'Container', 'Column']; // Inferred as List<String>
  
  print('$name $version is stable: $isStable');
  print('Common widgets: $widgets');
}

// 6. FUNCTIONS AS FIRST-CLASS OBJECTS
// Functions can be assigned to variables, passed as parameters
typedef Operation = int Function(int a, int b);

int add(int a, int b) => a + b;  // Arrow function syntax
int multiply(int a, int b) => a * b;

void performOperation(int x, int y, Operation op) {
  print('Result: ${op(x, y)}');
}

// 7. INHERITANCE & POLYMORPHISM
abstract class Shape {
  String name;
  
  Shape(this.name);
  
  // Abstract method - must be implemented by subclasses
  double calculateArea();
  
  void display() {
    print('Shape: $name, Area: ${calculateArea()}');
  }
}

class Rectangle extends Shape {
  double width;
  double height;
  
  Rectangle(this.width, this.height) : super('Rectangle');
  
  @override
  double calculateArea() {
    return width * height;
  }
}

class Circle extends Shape {
  double radius;
  
  Circle(this.radius) : super('Circle');
  
  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }
}

// 8. NAMED PARAMETERS & DEFAULT VALUES
class Button {
  final String text;
  final String color;
  final double width;
  final bool isEnabled;
  
  // Named parameters with default values
  Button({
    required this.text,
    this.color = 'blue',
    this.width = 100.0,
    this.isEnabled = true,
  });
  
  void printDetails() {
    print('Button: $text, Color: $color, Width: $width, Enabled: $isEnabled');
  }
}

// 9. ENUMS
enum UserRole {
  admin,
  moderator,
  user,
  guest
}

class User {
  String username;
  UserRole role;
  
  User(this.username, this.role);
  
  String getPermissionLevel() {
    switch (role) {
      case UserRole.admin:
        return 'Full access';
      case UserRole.moderator:
        return 'Moderate content';
      case UserRole.user:
        return 'Read and write';
      case UserRole.guest:
        return 'Read only';
    }
  }
}

// MAIN FUNCTION - Entry point to run examples
void main() {
  print('=== DART LANGUAGE FUNDAMENTALS ===\n');
  
  // 1. Classes & Objects
  print('1. CLASSES & OBJECTS:');
  var student = Student('Aanya', 20);
  student.introduce();
  print('Is adult? ${student.isAdult()}\n');
  
  // 2. Null Safety
  print('2. NULL SAFETY:');
  var profile = Profile('john_doe', email: 'john@example.com');
  profile.displayInfo();
  print('');
  
  // 3. Collections
  print('3. COLLECTIONS:');
  demonstrateCollections();
  print('');
  
  // 4. Type Inference
  print('4. TYPE INFERENCE:');
  demonstrateTypeInference();
  print('');
  
  // 5. Functions as First-Class Objects
  print('5. FUNCTIONS:');
  performOperation(10, 5, add);
  performOperation(10, 5, multiply);
  print('');
  
  // 6. Inheritance
  print('6. INHERITANCE & POLYMORPHISM:');
  Shape rectangle = Rectangle(5.0, 3.0);
  Shape circle = Circle(4.0);
  rectangle.display();
  circle.display();
  print('');
  
  // 7. Named Parameters
  print('7. NAMED PARAMETERS:');
  var button1 = Button(text: 'Submit');
  var button2 = Button(text: 'Cancel', color: 'red', width: 150.0);
  button1.printDetails();
  button2.printDetails();
  print('');
  
  // 8. Enums
  print('8. ENUMS:');
  var user = User('admin_user', UserRole.admin);
  print('${user.username} permissions: ${user.getPermissionLevel()}');
  
  print('\n=== To run async example, call: demonstrateAsync() ===');
}

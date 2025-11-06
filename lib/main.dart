// main.dart
import 'bank.dart';

void main() {
  final bank = Bank();

  bank.createSavings("S1", "Alice", 1000);
  bank.createChecking("C1", "Bob", 200);
  bank.createPremium("P1", "Carol", 15000);
  bank.createStudent("ST1", "Dave", 400);

  bank.find("S1").deposit(200);
  bank.find("S1").withdraw(100);

  bank.transfer("P1", "S1", 5000);

  bank.report();
  bank.applyMonthlyInterest();
  bank.resetMonthlyCounters();

  print("\n--- Account Details (S1) ---");
  for (var log in bank.find("S1").history) {
    print(log);
  }
}

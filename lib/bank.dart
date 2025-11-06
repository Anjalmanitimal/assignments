// bank.dart
import 'bank_account.dart';
import 'exceptions.dart';

class Bank {
  final Map<String, BankAccount> _accounts = {};

  void _unique(String number) {
    if (_accounts.containsKey(number)) {
      throw Exception("Account number already exists");
    }
  }

  BankAccount createSavings(String num, String name, double bal) {
    _unique(num);
    return _accounts[num] = SavingsAccount(num, name, bal);
  }

  BankAccount createChecking(String num, String name, double bal) {
    _unique(num);
    return _accounts[num] = CheckingAccount(num, name, bal);
  }

  BankAccount createPremium(String num, String name, double bal) {
    _unique(num);
    return _accounts[num] = PremiumAccount(num, name, bal);
  }

  BankAccount createStudent(String num, String name, double bal) {
    _unique(num);
    return _accounts[num] = StudentAccount(num, name, bal);
  }

  BankAccount find(String num) {
    if (!_accounts.containsKey(num)) {
      throw AccountNotFoundException("Account $num not found");
    }
    return _accounts[num]!;
  }

  void transfer(String from, String to, double amount) {
    var a = find(from);
    var b = find(to);

    a.withdraw(amount);
    b.deposit(amount);

    a.addTransaction("Transferred \$${amount} to $to");
    b.addTransaction("Received \$${amount} from $from");
  }

  void applyMonthlyInterest() {
    for (var acc in _accounts.values) {
      // ensure we call the interest method only on InterestBearing accounts
      if (acc is InterestBearing) {
        // cast to InterestBearing then call the method
        (acc as InterestBearing).applyMonthlyInterest();
      }
    }
  }

  void resetCounters() {
    for (var acc in _accounts.values) acc.resetMonthlyCounters();
  }

  void report() {
    print("----- BANK REPORT -----");
    for (var a in _accounts.values) a.displayInfo();
  }
}

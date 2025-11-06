// bank.dart
import 'bank_account.dart';
import 'exceptions.dart';

class Bank {
  final Map<String, BankAccount> _accounts = {};

  void _ensureUnique(String acc) {
    if (_accounts.containsKey(acc)) {
      throw Exception("Account number already exists");
    }
  }

  BankAccount createSavings(String acc, String name, double bal) {
    _ensureUnique(acc);
    return _accounts[acc] = SavingsAccount(acc, name, bal);
  }

  BankAccount createChecking(String acc, String name, double bal) {
    _ensureUnique(acc);
    return _accounts[acc] = CheckingAccount(acc, name, bal);
  }

  BankAccount createPremium(String acc, String name, double bal) {
    _ensureUnique(acc);
    return _accounts[acc] = PremiumAccount(acc, name, bal);
  }

  BankAccount createStudent(String acc, String name, double bal) {
    _ensureUnique(acc);
    return _accounts[acc] = StudentAccount(acc, name, bal);
  }

  BankAccount find(String acc) {
    if (!_accounts.containsKey(acc)) {
      throw AccountNotFoundException("Account $acc not found");
    }
    return _accounts[acc]!;
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
      if (acc is InterestBearing) {
        acc.applyMonthlyInterest();
      }
    }
  }

  void resetMonthlyCounters() {
    for (var acc in _accounts.values) {
      acc.resetMonthlyCounters();
    }
  }

  void report() {
    print("----- BANK REPORT -----");
    for (var acc in _accounts.values) {
      acc.displayInfo();
    }
  }
}

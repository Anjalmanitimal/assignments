// bank_account.dart
import 'exceptions.dart';

/// Base abstract account class
abstract class BankAccount {
  final String _accountNumber;
  String _holderName;
  double _balance;

  final List<String> _history = [];

  BankAccount(this._accountNumber, this._holderName, this._balance);

  String get accountNumber => _accountNumber;
  String get holderName => _holderName;
  double get balance => _balance;

  set holderName(String name) {
    if (name.trim().isEmpty) throw Exception("Holder name cannot be empty");
    _holderName = name;
  }

  void setBalance(double value) => _balance = value;

  void addTransaction(String msg) {
    _history.add("${DateTime.now()}: $msg");
  }

  List<String> get history => List.unmodifiable(_history);

  void deposit(double amount);
  void withdraw(double amount);

  void resetMonthlyCounters() {}

  void displayInfo() {
    print("[$_accountNumber] $_holderName — \$${_balance.toStringAsFixed(2)}");
  }
}

/// Interface for interest-bearing accounts
abstract class InterestBearing {
  double calculateMonthlyInterestAmount();
  void applyMonthlyInterest();
}

/// --------------------
/// Savings Account 
/// --------------------
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500;
  static const int maxWithdrawals = 3;
  static const double annualInterest = 0.02;

  int _monthlyWithdrawals = 0;

  SavingsAccount(String acc, String holder, double initialBalance)
      : super(acc, holder, initialBalance) {
    if (initialBalance < minBalance) {
      throw MinimumBalanceException("Savings account requires minimum \$500");
    }
    addTransaction("Savings account opened with \$${initialBalance}");
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw InvalidAmountException();
    setBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw InvalidAmountException();

    if (_monthlyWithdrawals >= maxWithdrawals) {
      throw Exception("Savings account monthly withdrawal limit reached");
    }

    if (balance - amount < minBalance) {
      throw MinimumBalanceException("Cannot go below required minimum balance");
    }

    setBalance(balance - amount);
    _monthlyWithdrawals++;
    addTransaction("Withdrew \$${amount}");
  }

  @override
  void resetMonthlyCounters() => _monthlyWithdrawals = 0;

  @override
  double calculateMonthlyInterestAmount() {
    return balance * (annualInterest / 12);
  }

  @override
  void applyMonthlyInterest() {
    double interest = calculateMonthlyInterestAmount();
    setBalance(balance + interest);
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
}

/// --------------------
/// Checking Account
/// --------------------
class CheckingAccount extends BankAccount {
  CheckingAccount(String acc, String holder, double initialBalance)
      : super(acc, holder, initialBalance) {
    addTransaction("Checking account opened with \$${initialBalance}");
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw InvalidAmountException();
    setBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw InvalidAmountException();

    double newBalance = balance - amount;
    setBalance(newBalance);
    addTransaction("Withdrew \$${amount}");

    if (newBalance < 0) {
      setBalance(balance - 35);
      addTransaction("Overdraft fee charged: -\$35");
    }
  }
}

/// --------------------
/// Premium Account
/// --------------------
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double annualInterest = 0.05;

  PremiumAccount(String acc, String holder, double initialBalance)
      : super(acc, holder, initialBalance) {
    if (initialBalance < minBalance) {
      throw MinimumBalanceException("Premium requires minimum \$10,000");
    }
    addTransaction("Premium account opened with \$${initialBalance}");
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) throw InvalidAmountException();
    setBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      throw MinimumBalanceException("Cannot violate Premium minimum balance");
    }
    setBalance(balance - amount);
    addTransaction("Withdrew \$${amount}");
  }

  @override
  double calculateMonthlyInterestAmount() {
    return balance * (annualInterest / 12);
  }

  @override
  void applyMonthlyInterest() {
    double interest = calculateMonthlyInterestAmount();
    setBalance(balance + interest);
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
}

/// --------------------
/// Student Account
/// --------------------
class StudentAccount extends BankAccount {
  static const double maxBalance = 5000;

  StudentAccount(String acc, String holder, double initialBalance)
      : super(acc, holder, initialBalance) {
    if (initialBalance > maxBalance) {
      throw ExceedsMaxBalanceException("Student account max is \$5000");
    }
    addTransaction("Student account opened with \$${initialBalance}");
  }

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      throw ExceedsMaxBalanceException("Deposit exceeds max balance");
    }
    setBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount > balance) throw InsufficientFundsException();
    setBalance(balance - amount);
    addTransaction("Withdrew \$${amount}");
  }
}

// exceptions.dart

class InvalidAmountException implements Exception {
  final String message;
  InvalidAmountException([this.message = 'Amount must be greater than 0']);
  @override
  String toString() => 'InvalidAmountException: $message';
}

class InsufficientFundsException implements Exception {
  final String message;
  InsufficientFundsException([this.message = 'Insufficient funds']);
  @override
  String toString() => 'InsufficientFundsException: $message';
}

class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException([this.message = 'Account not found']);
  @override
  String toString() => 'AccountNotFoundException: $message';
}

class MinimumBalanceException implements Exception {
  final String message;
  MinimumBalanceException([this.message = 'Minimum balance requirement violated']);
  @override
  String toString() => 'MinimumBalanceException: $message';
}

class ExceedsMaxBalanceException implements Exception {
  final String message;
  ExceedsMaxBalanceException([this.message = 'Balance exceeds maximum allowed']);
  @override
  String toString() => 'ExceedsMaxBalanceException: $message';
}

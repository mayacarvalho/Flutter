// Salvar os dados da conta de usuário.

import '../entities/entities.dart';

abstract class SaveCurrentAccount {
  Future<void> save(AccountEntity account);
}

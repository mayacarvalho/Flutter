import 'package:firstapp/data/cache/save_secure_cache_storage.dart';
import 'package:firstapp/domain/entities/account_entity.dart';
import 'package:firstapp/domain/helpers/domain_error.dart';
import 'package:firstapp/domain/usecases/save_current_account.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

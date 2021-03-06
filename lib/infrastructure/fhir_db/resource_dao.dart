import 'package:fhir/fhir_r4.dart';
import 'package:sembast/sembast.dart';

import 'fhir_db.dart';

class ResourceDao {
  StoreRef<String, Map<String, dynamic>> _resourceStore;

  ResourceDao(String resourceType) {
    _resourceStore = stringMapStoreFactory.store(resourceType);
  }

  Future<Database> get _db async => await FhirDb.instance.database;

  Future insert(Resource resource) async {
    await _resourceStore.add(await _db, resource.toJson());
  }

  Future update(Resource resource) async {
    final finder = Finder(filter: Filter.byKey(resource.id));
    await _resourceStore.update(await _db, resource.toJson(), finder: finder);
  }

  Future find({Resource resource, Finder oldFinder}) async {
    final finder = oldFinder != null
        ? oldFinder
        : Finder(filter: Filter.byKey(resource.id));
    return await _search(finder);
  }

  Future delete(Resource resource) async {
    final finder = Finder(filter: Filter.byKey(resource.id));
    await _resourceStore.delete(await _db, finder: finder);
  }

  Future<List<Resource>> getAllSortedById() async {
    final finder = Finder(sortOrders: [SortOrder('id')]);
    return await _search(finder);
  }

  Future<List<Resource>> _search(Finder finder) async {
    final recordSnapshots =
        await _resourceStore.find(await _db, finder: finder);

    return recordSnapshots.map((snapshot) {
      final resource = Resource.fromJson(snapshot.value);
      return resource;
    }).toList();
  }
}

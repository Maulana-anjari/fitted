import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitted/core/error/failure.dart';
import 'package:fitted/core/network/api_exception.dart';
import 'package:fitted/features/wardrobe/data/datasources/wardrobe_local_datasource.dart';
import 'package:fitted/features/wardrobe/data/datasources/wardrobe_remote_datasource.dart';
import 'package:fitted/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:fitted/features/wardrobe/domain/models/clothing_category.dart';
import 'package:fitted/features/wardrobe/domain/models/wardrobe_item.dart';

class _MockRemote extends Mock implements WardrobeRemoteDatasource {}

class _MockLocal extends Mock implements WardrobeLocalDatasource {}

WardrobeItem _item(String id) => WardrobeItem(
      id: id,
      userId: 'u1',
      category: ClothingCategory.values.first,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late WardrobeRepositoryImpl repo;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repo = WardrobeRepositoryImpl(remote: remote, local: local, userId: 'u1');

    // mocktail needs a fallback value for any matcher on WardrobeItem args.
    registerFallbackValue(_item('fallback'));
  });

  group('getItems', () {
    test('returns remote items and caches them', () async {
      final items = [_item('1'), _item('2')];
      when(() => remote.getItems(
            category: any(named: 'category'),
            color: any(named: 'color'),
            season: any(named: 'season'),
            searchQuery: any(named: 'searchQuery'),
            userId: 'u1',
          )).thenAnswer((_) async => items);
      when(() => local.cacheItems(any())).thenAnswer((_) async {});

      final result = await repo.getItems();

      expect(result.length, 2);
      verify(() => local.cacheItems(items)).called(1);
    });

    test('falls back to local cache when remote throws and cache is non-empty',
        () async {
      final cached = [_item('cached')];
      when(() => remote.getItems(
            category: any(named: 'category'),
            color: any(named: 'color'),
            season: any(named: 'season'),
            searchQuery: any(named: 'searchQuery'),
            userId: 'u1',
          )).thenThrow(const ServerException(message: 'down', statusCode: 500));
      when(() => local.getCachedItems()).thenAnswer((_) async => cached);

      final result = await repo.getItems();

      expect(result.length, 1);
      expect(result.first.id, 'cached');
    });

    test('rethrows when remote throws and cache is empty', () async {
      when(() => remote.getItems(
            category: any(named: 'category'),
            color: any(named: 'color'),
            season: any(named: 'season'),
            searchQuery: any(named: 'searchQuery'),
            userId: 'u1',
          )).thenThrow(const ServerException(message: 'down'));
      when(() => local.getCachedItems()).thenAnswer((_) async => []);

      // Remote throws ServerException, which ErrorHandler.guard would map to
      // ServerFailure — but getItems uses a bare try/catch that rethrows the
      // original Exception when the cache is empty.
      expect(() => repo.getItems(), throwsA(isA<Exception>()));
    });
  });

  group('addItem', () {
    test('inserts via remote and caches the created item', () async {
      final input = _item('new');
      final created = _item('new');
      when(() => remote.insertItem(any())).thenAnswer((_) async => created);
      when(() => local.cacheItem(any())).thenAnswer((_) async {});

      final result = await repo.addItem(input);

      expect(result.id, 'new');
      verify(() => local.cacheItem(created)).called(1);
    });

    test('maps remote exception to Failure', () async {
      when(() => remote.insertItem(any()))
          .thenThrow(const ServerException(message: 'nope'));

      expect(() => repo.addItem(_item('x')), throwsA(isA<Failure>()));
    });
  });

  group('updateItem', () {
    test('updates via remote and caches the updated item', () async {
      final input = _item('1');
      when(() => remote.updateItem(any())).thenAnswer((_) async => input);
      when(() => local.cacheItem(any())).thenAnswer((_) async {});

      final result = await repo.updateItem(input);

      expect(result.id, '1');
      verify(() => local.cacheItem(input)).called(1);
    });
  });

  group('deleteItem', () {
    test('deletes via remote and removes from local cache', () async {
      when(() => remote.deleteItem('1', 'u1')).thenAnswer((_) async {});
      when(() => local.removeItem('1')).thenAnswer((_) async {});

      await repo.deleteItem('1');

      verify(() => remote.deleteItem('1', 'u1')).called(1);
      verify(() => local.removeItem('1')).called(1);
    });

    test('does not touch local cache when remote throws', () async {
      when(() => remote.deleteItem('1', 'u1'))
          .thenThrow(const ServerException(message: 'down'));

      expect(() => repo.deleteItem('1'), throwsA(isA<Failure>()));
      verifyNever(() => local.removeItem('1'));
    });
  });

  group('archiveItem', () {
    test('archives via remote and removes from local cache', () async {
      when(() => remote.archiveItem('1', 'u1')).thenAnswer((_) async {});
      when(() => local.removeItem('1')).thenAnswer((_) async {});

      await repo.archiveItem('1');

      verify(() => remote.archiveItem('1', 'u1')).called(1);
      verify(() => local.removeItem('1')).called(1);
    });
  });
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ItemDao? _itemDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT, `created_at` INTEGER, `updated_at` INTEGER, `due` INTEGER, `completed_at` INTEGER, `flag` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `repeat_id` INTEGER, `parent_id` INTEGER, `category_id` INTEGER, FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, FOREIGN KEY (`repeat_id`) REFERENCES `repeats` (`id`) ON UPDATE CASCADE ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _itemModelInsertionAdapter = InsertionAdapter(
            database,
            'items',
            (ItemModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt,
                  'due': item.due,
                  'completed_at': item.completedAt,
                  'flag': item.flag,
                  'priority': item.priority,
                  'repeat_id': item.repeatId,
                  'parent_id': item.parentId,
                  'category_id': item.categoryId
                }),
        _itemModelUpdateAdapter = UpdateAdapter(
            database,
            'items',
            ['id'],
            (ItemModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt,
                  'due': item.due,
                  'completed_at': item.completedAt,
                  'flag': item.flag,
                  'priority': item.priority,
                  'repeat_id': item.repeatId,
                  'parent_id': item.parentId,
                  'category_id': item.categoryId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ItemModel> _itemModelInsertionAdapter;

  final UpdateAdapter<ItemModel> _itemModelUpdateAdapter;

  @override
  Future<List<ItemModel>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM items',
        mapper: (Map<String, Object?> row) => ItemModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            due: row['due'] as int?,
            completedAt: row['completed_at'] as int?,
            flag: row['flag'] as int,
            priority: row['priority'] as int,
            repeatId: row['repeat_id'] as int?,
            parentId: row['parent_id'] as int?,
            categoryId: row['category_id'] as int?));
  }

  @override
  Future<ItemModel?> getItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ItemModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            due: row['due'] as int?,
            completedAt: row['completed_at'] as int?,
            flag: row['flag'] as int,
            priority: row['priority'] as int,
            repeatId: row['repeat_id'] as int?,
            parentId: row['parent_id'] as int?,
            categoryId: row['category_id'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<ItemModel>> getItemsByCategory(int categoryId) async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE category_id = ?1',
        mapper: (Map<String, Object?> row) => ItemModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            due: row['due'] as int?,
            completedAt: row['completed_at'] as int?,
            flag: row['flag'] as int,
            priority: row['priority'] as int,
            repeatId: row['repeat_id'] as int?,
            parentId: row['parent_id'] as int?,
            categoryId: row['category_id'] as int?),
        arguments: [categoryId]);
  }

  @override
  Future<List<ItemModel>> getItemsByDue(
    int startOfDay,
    int endOfDay,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE due >= ?1 AND due <= ?2',
        mapper: (Map<String, Object?> row) => ItemModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            due: row['due'] as int?,
            completedAt: row['completed_at'] as int?,
            flag: row['flag'] as int,
            priority: row['priority'] as int,
            repeatId: row['repeat_id'] as int?,
            parentId: row['parent_id'] as int?,
            categoryId: row['category_id'] as int?),
        arguments: [startOfDay, endOfDay]);
  }

  @override
  Future<int?> deleteItem(int id) async {
    return _queryAdapter.query('DELETE FROM items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<List<ItemModel>> getUpcomingItems(
    int now,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE due > ?1 ORDER BY due ASC LIMIT ?2',
        mapper: (Map<String, Object?> row) => ItemModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            due: row['due'] as int?,
            completedAt: row['completed_at'] as int?,
            flag: row['flag'] as int,
            priority: row['priority'] as int,
            repeatId: row['repeat_id'] as int?,
            parentId: row['parent_id'] as int?,
            categoryId: row['category_id'] as int?),
        arguments: [now, limit]);
  }

  @override
  Future<List<ItemModel>> getCompletedItems() async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE is_completed = 1',
        mapper: (Map<String, Object?> row) => ItemModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            due: row['due'] as int?,
            completedAt: row['completed_at'] as int?,
            flag: row['flag'] as int,
            priority: row['priority'] as int,
            repeatId: row['repeat_id'] as int?,
            parentId: row['parent_id'] as int?,
            categoryId: row['category_id'] as int?));
  }

  @override
  Future<int> createItem(ItemModel item) {
    return _itemModelInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItem(ItemModel item) {
    return _itemModelUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }
}

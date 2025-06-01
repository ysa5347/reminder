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

  CategoryDao? _categoryDaoInstance;

  NotificationDao? _notificationDaoInstance;

  RepeatDao? _repeatDaoInstance;

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
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT, `color` TEXT, `icon` TEXT, `created_at` INTEGER, `updated_at` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notifications` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `created_at` INTEGER, `item_id` INTEGER, `time` INTEGER, `priority` INTEGER NOT NULL, `queue` INTEGER NOT NULL, FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON UPDATE CASCADE ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `repeats` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `weekday_byte` INTEGER, `week_byte` INTEGER, `created_at` INTEGER, `updated_at` INTEGER, `start_day` INTEGER, `end_day` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }

  @override
  RepeatDao get repeatDao {
    return _repeatDaoInstance ??= _$RepeatDao(database, changeListener);
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
  Future<List<ItemModel>> getItemsByStatus(int flag) async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE flag = ?1',
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
        arguments: [flag]);
  }

  @override
  Future<List<ItemModel>> getItemsByPriority(int priority) async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE priority = ?1',
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
        arguments: [priority]);
  }

  @override
  Future<List<ItemModel>> getItemsByDateRange(
    int startTime,
    int endTime,
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
        arguments: [startTime, endTime]);
  }

  @override
  Future<List<ItemModel>> getOverdueItems(int currentTime) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE due < ?1 AND flag != 1',
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
        arguments: [currentTime]);
  }

  @override
  Future<List<ItemModel>> getTodayItems(
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
  Future<List<ItemModel>> getUpcomingItems(
    int currentTime,
    int endTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE due >= ?1 AND due <= ?2 AND flag != 1 ORDER BY due ASC',
        mapper: (Map<String, Object?> row) => ItemModel(id: row['id'] as int?, title: row['title'] as String, description: row['description'] as String?, createdAt: row['created_at'] as int?, updatedAt: row['updated_at'] as int?, due: row['due'] as int?, completedAt: row['completed_at'] as int?, flag: row['flag'] as int, priority: row['priority'] as int, repeatId: row['repeat_id'] as int?, parentId: row['parent_id'] as int?, categoryId: row['category_id'] as int?),
        arguments: [currentTime, endTime]);
  }

  @override
  Future<List<ItemModel>> getCompletedItems() async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE flag = 1',
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
  Future<List<ItemModel>> getItemsByRepeat(int repeatId) async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE repeat_id = ?1',
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
        arguments: [repeatId]);
  }

  @override
  Future<List<ItemModel>> getSubItems(int parentId) async {
    return _queryAdapter.queryList('SELECT * FROM items WHERE parent_id = ?1',
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
        arguments: [parentId]);
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE (title LIKE ?1 OR description LIKE ?1)',
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
        arguments: [query]);
  }

  @override
  Future<int?> getItemCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM items',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getCompletedItemCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM items WHERE flag = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingItemCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM items WHERE flag = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<ItemModel>> getHighPriorityItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE priority <= 2 AND flag != 1 ORDER BY priority ASC, due ASC',
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
  Future<List<ItemModel>> getRecentItems(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items ORDER BY created_at DESC LIMIT ?1',
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
        arguments: [limit]);
  }

  @override
  Future<List<ItemModel>> getRecentlyUpdatedItems(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM items ORDER BY updated_at DESC LIMIT ?1',
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
        arguments: [limit]);
  }

  @override
  Future<List<ItemModel>> getUncategorizedItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE category_id IS NULL',
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
  Future<List<ItemModel>> getRecurringItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM items WHERE repeat_id IS NOT NULL',
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
  Future<List<ItemModel>> getParentItems() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT parent.* FROM items parent WHERE EXISTS (SELECT 1 FROM items child WHERE child.parent_id = parent.id)',
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
  Future<int?> markItemAsCompleted(
    int id,
    int completedAt,
  ) async {
    return _queryAdapter.query(
        'UPDATE items SET flag = 1, completed_at = ?2 WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, completedAt]);
  }

  @override
  Future<int?> markItemAsUncompleted(int id) async {
    return _queryAdapter.query(
        'UPDATE items SET flag = 0, completed_at = NULL WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteItem(int id) async {
    return _queryAdapter.query('DELETE FROM items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int> insertItem(ItemModel item) {
    return _itemModelInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItem(ItemModel item) {
    return _itemModelUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryModelInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'color': item.color,
                  'icon': item.icon,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                }),
        _categoryModelUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'color': item.color,
                  'icon': item.icon,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryModel> _categoryModelInsertionAdapter;

  final UpdateAdapter<CategoryModel> _categoryModelUpdateAdapter;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return _queryAdapter.queryList('SELECT * FROM categories',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            color: row['color'] as String?,
            icon: row['icon'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?));
  }

  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            color: row['color'] as String?,
            icon: row['icon'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<CategoryModel>> getCategoriesByName(String name) async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE title LIKE ?1',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String?,
            color: row['color'] as String?,
            icon: row['icon'] as String?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?),
        arguments: [name]);
  }

  @override
  Future<int?> getItemCountByCategory(int categoryId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM items WHERE category_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [categoryId]);
  }

  @override
  Future<int?> deleteCategory(int id) async {
    return _queryAdapter.query('DELETE FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> checkCategoryUsage(int categoryId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM items WHERE category_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [categoryId]);
  }

  @override
  Future<int> insertCategory(CategoryModel category) {
    return _categoryModelInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCategory(CategoryModel category) {
    return _categoryModelUpdateAdapter.updateAndReturnChangedRows(
        category, OnConflictStrategy.abort);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notificationModelInsertionAdapter = InsertionAdapter(
            database,
            'notifications',
            (NotificationModel item) => <String, Object?>{
                  'id': item.id,
                  'created_at': item.createdAt,
                  'item_id': item.itemId,
                  'time': item.time,
                  'priority': item.priority,
                  'queue': item.queue
                }),
        _notificationModelUpdateAdapter = UpdateAdapter(
            database,
            'notifications',
            ['id'],
            (NotificationModel item) => <String, Object?>{
                  'id': item.id,
                  'created_at': item.createdAt,
                  'item_id': item.itemId,
                  'time': item.time,
                  'priority': item.priority,
                  'queue': item.queue
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotificationModel> _notificationModelInsertionAdapter;

  final UpdateAdapter<NotificationModel> _notificationModelUpdateAdapter;

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    return _queryAdapter.queryList('SELECT * FROM notifications',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int));
  }

  @override
  Future<NotificationModel?> getNotificationById(int id) async {
    return _queryAdapter.query('SELECT * FROM notifications WHERE id = ?1',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int),
        arguments: [id]);
  }

  @override
  Future<List<NotificationModel>> getNotificationsByItemId(int itemId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications WHERE item_id = ?1',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int),
        arguments: [itemId]);
  }

  @override
  Future<List<NotificationModel>> getNotificationsByTimeRange(
    int startTime,
    int endTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications WHERE time >= ?1 AND time <= ?2',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int),
        arguments: [startTime, endTime]);
  }

  @override
  Future<List<NotificationModel>> getOverdueNotifications(
      int currentTime) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications WHERE time <= ?1 ORDER BY time ASC',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int),
        arguments: [currentTime]);
  }

  @override
  Future<List<NotificationModel>> getNotificationsByPriority(
      int priority) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications WHERE priority = ?1',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int),
        arguments: [priority]);
  }

  @override
  Future<List<NotificationModel>> getNotificationsByQueue(int queue) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications WHERE queue = ?1',
        mapper: (Map<String, Object?> row) => NotificationModel(
            id: row['id'] as int?,
            createdAt: row['created_at'] as int?,
            itemId: row['item_id'] as int?,
            time: row['time'] as int?,
            priority: row['priority'] as int,
            queue: row['queue'] as int),
        arguments: [queue]);
  }

  @override
  Future<int?> deleteNotification(int id) async {
    return _queryAdapter.query('DELETE FROM notifications WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteNotificationsByItemId(int itemId) async {
    return _queryAdapter.query('DELETE FROM notifications WHERE item_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [itemId]);
  }

  @override
  Future<int?> getNotificationCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM notifications',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertNotification(NotificationModel notification) {
    return _notificationModelInsertionAdapter.insertAndReturnId(
        notification, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateNotification(NotificationModel notification) {
    return _notificationModelUpdateAdapter.updateAndReturnChangedRows(
        notification, OnConflictStrategy.abort);
  }
}

class _$RepeatDao extends RepeatDao {
  _$RepeatDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _repeatModelInsertionAdapter = InsertionAdapter(
            database,
            'repeats',
            (RepeatModel item) => <String, Object?>{
                  'id': item.id,
                  'weekday_byte': item.weekdayByte,
                  'week_byte': item.weekByte,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt,
                  'start_day': item.startDay,
                  'end_day': item.endDay
                }),
        _repeatModelUpdateAdapter = UpdateAdapter(
            database,
            'repeats',
            ['id'],
            (RepeatModel item) => <String, Object?>{
                  'id': item.id,
                  'weekday_byte': item.weekdayByte,
                  'week_byte': item.weekByte,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt,
                  'start_day': item.startDay,
                  'end_day': item.endDay
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RepeatModel> _repeatModelInsertionAdapter;

  final UpdateAdapter<RepeatModel> _repeatModelUpdateAdapter;

  @override
  Future<List<RepeatModel>> getAllRepeats() async {
    return _queryAdapter.queryList('SELECT * FROM repeats',
        mapper: (Map<String, Object?> row) => RepeatModel(
            id: row['id'] as int?,
            weekdayByte: row['weekday_byte'] as int?,
            weekByte: row['week_byte'] as int?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            startDay: row['start_day'] as int?,
            endDay: row['end_day'] as int?));
  }

  @override
  Future<RepeatModel?> getRepeatById(int id) async {
    return _queryAdapter.query('SELECT * FROM repeats WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RepeatModel(
            id: row['id'] as int?,
            weekdayByte: row['weekday_byte'] as int?,
            weekByte: row['week_byte'] as int?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            startDay: row['start_day'] as int?,
            endDay: row['end_day'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<RepeatModel>> getActiveRepeats(int currentTime) async {
    return _queryAdapter.queryList(
        'SELECT * FROM repeats WHERE start_day <= ?1 AND (end_day IS NULL OR end_day >= ?1)',
        mapper: (Map<String, Object?> row) => RepeatModel(id: row['id'] as int?, weekdayByte: row['weekday_byte'] as int?, weekByte: row['week_byte'] as int?, createdAt: row['created_at'] as int?, updatedAt: row['updated_at'] as int?, startDay: row['start_day'] as int?, endDay: row['end_day'] as int?),
        arguments: [currentTime]);
  }

  @override
  Future<List<RepeatModel>> getExpiredRepeats(int currentTime) async {
    return _queryAdapter.queryList(
        'SELECT * FROM repeats WHERE end_day IS NOT NULL AND end_day < ?1',
        mapper: (Map<String, Object?> row) => RepeatModel(
            id: row['id'] as int?,
            weekdayByte: row['weekday_byte'] as int?,
            weekByte: row['week_byte'] as int?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            startDay: row['start_day'] as int?,
            endDay: row['end_day'] as int?),
        arguments: [currentTime]);
  }

  @override
  Future<List<RepeatModel>> getWeeklyRepeats() async {
    return _queryAdapter.queryList(
        'SELECT * FROM repeats WHERE weekday_byte IS NOT NULL AND weekday_byte != 0',
        mapper: (Map<String, Object?> row) => RepeatModel(
            id: row['id'] as int?,
            weekdayByte: row['weekday_byte'] as int?,
            weekByte: row['week_byte'] as int?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            startDay: row['start_day'] as int?,
            endDay: row['end_day'] as int?));
  }

  @override
  Future<List<RepeatModel>> getMonthlyRepeats() async {
    return _queryAdapter.queryList(
        'SELECT * FROM repeats WHERE week_byte IS NOT NULL AND week_byte != 0',
        mapper: (Map<String, Object?> row) => RepeatModel(
            id: row['id'] as int?,
            weekdayByte: row['weekday_byte'] as int?,
            weekByte: row['week_byte'] as int?,
            createdAt: row['created_at'] as int?,
            updatedAt: row['updated_at'] as int?,
            startDay: row['start_day'] as int?,
            endDay: row['end_day'] as int?));
  }

  @override
  Future<int?> getItemCountByRepeat(int repeatId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM items WHERE repeat_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [repeatId]);
  }

  @override
  Future<int?> deleteRepeat(int id) async {
    return _queryAdapter.query('DELETE FROM repeats WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> checkRepeatUsage(int repeatId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM items WHERE repeat_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [repeatId]);
  }

  @override
  Future<int> insertRepeat(RepeatModel repeat) {
    return _repeatModelInsertionAdapter.insertAndReturnId(
        repeat, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateRepeat(RepeatModel repeat) {
    return _repeatModelUpdateAdapter.updateAndReturnChangedRows(
        repeat, OnConflictStrategy.abort);
  }
}

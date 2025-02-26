// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_helper.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, Card> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ignoredMeta =
      const VerificationMeta('ignored');
  @override
  late final GeneratedColumn<bool> ignored = GeneratedColumn<bool>(
      'ignored', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ignored" IN (0, 1))'));
  static const VerificationMeta _cardTypeMeta =
      const VerificationMeta('cardType');
  @override
  late final GeneratedColumnWithTypeConverter<GameCardType, int> cardType =
      GeneratedColumn<int>('card_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<GameCardType>($CardsTable.$convertercardType);
  @override
  List<GeneratedColumn> get $columns => [id, description, ignored, cardType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<Card> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('ignored')) {
      context.handle(_ignoredMeta,
          ignored.isAcceptableOrUnknown(data['ignored']!, _ignoredMeta));
    } else if (isInserting) {
      context.missing(_ignoredMeta);
    }
    context.handle(_cardTypeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Card(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      ignored: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ignored'])!,
      cardType: $CardsTable.$convertercardType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}card_type'])!),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }

  static TypeConverter<GameCardType, int> $convertercardType =
      const GameCardTypeConverter();
}

class Card extends DataClass implements Insertable<Card> {
  final int id;
  final String description;
  final bool ignored;
  final GameCardType cardType;
  const Card(
      {required this.id,
      required this.description,
      required this.ignored,
      required this.cardType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['ignored'] = Variable<bool>(ignored);
    {
      map['card_type'] =
          Variable<int>($CardsTable.$convertercardType.toSql(cardType));
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      description: Value(description),
      ignored: Value(ignored),
      cardType: Value(cardType),
    );
  }

  factory Card.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      ignored: serializer.fromJson<bool>(json['ignored']),
      cardType: serializer.fromJson<GameCardType>(json['cardType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'ignored': serializer.toJson<bool>(ignored),
      'cardType': serializer.toJson<GameCardType>(cardType),
    };
  }

  Card copyWith(
          {int? id,
          String? description,
          bool? ignored,
          GameCardType? cardType}) =>
      Card(
        id: id ?? this.id,
        description: description ?? this.description,
        ignored: ignored ?? this.ignored,
        cardType: cardType ?? this.cardType,
      );
  Card copyWithCompanion(CardsCompanion data) {
    return Card(
      id: data.id.present ? data.id.value : this.id,
      description:
          data.description.present ? data.description.value : this.description,
      ignored: data.ignored.present ? data.ignored.value : this.ignored,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('ignored: $ignored, ')
          ..write('cardType: $cardType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description, ignored, cardType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Card &&
          other.id == this.id &&
          other.description == this.description &&
          other.ignored == this.ignored &&
          other.cardType == this.cardType);
}

class CardsCompanion extends UpdateCompanion<Card> {
  final Value<int> id;
  final Value<String> description;
  final Value<bool> ignored;
  final Value<GameCardType> cardType;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.ignored = const Value.absent(),
    this.cardType = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required bool ignored,
    required GameCardType cardType,
  })  : description = Value(description),
        ignored = Value(ignored),
        cardType = Value(cardType);
  static Insertable<Card> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<bool>? ignored,
    Expression<int>? cardType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (ignored != null) 'ignored': ignored,
      if (cardType != null) 'card_type': cardType,
    });
  }

  CardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? description,
      Value<bool>? ignored,
      Value<GameCardType>? cardType}) {
    return CardsCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      ignored: ignored ?? this.ignored,
      cardType: cardType ?? this.cardType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (ignored.present) {
      map['ignored'] = Variable<bool>(ignored.value);
    }
    if (cardType.present) {
      map['card_type'] =
          Variable<int>($CardsTable.$convertercardType.toSql(cardType.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('ignored: $ignored, ')
          ..write('cardType: $cardType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cards];
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required String description,
  required bool ignored,
  required GameCardType cardType,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<String> description,
  Value<bool> ignored,
  Value<GameCardType> cardType,
});

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ignored => $composableBuilder(
      column: $table.ignored, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<GameCardType, GameCardType, int>
      get cardType => $composableBuilder(
          column: $table.cardType,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ignored => $composableBuilder(
      column: $table.ignored, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cardType => $composableBuilder(
      column: $table.cardType, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get ignored =>
      $composableBuilder(column: $table.ignored, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameCardType, int> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    Card,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
    Card,
    PrefetchHooks Function()> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<bool> ignored = const Value.absent(),
            Value<GameCardType> cardType = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            description: description,
            ignored: ignored,
            cardType: cardType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String description,
            required bool ignored,
            required GameCardType cardType,
          }) =>
              CardsCompanion.insert(
            id: id,
            description: description,
            ignored: ignored,
            cardType: cardType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    Card,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (Card, BaseReferences<_$AppDatabase, $CardsTable, Card>),
    Card,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
}

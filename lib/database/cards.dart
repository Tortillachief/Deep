import 'package:deep/widgets/game_card.dart';
import 'package:drift/drift.dart';

class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 1, max: 1000)();
  BoolColumn get ignored => boolean()();
  IntColumn get cardType => integer().map(const GameCardTypeConverter())();
}

class GameCardTypeConverter extends TypeConverter<GameCardType, int> {
  const GameCardTypeConverter();

  @override
  GameCardType fromSql(int fromDb) {
    return GameCardType.values[fromDb]; // Convert int → Enum
  }

  @override
  int toSql(GameCardType value) {
    return value.index; // Convert Enum → int
  }
}
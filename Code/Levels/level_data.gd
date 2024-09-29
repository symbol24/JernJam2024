class_name LevelData extends Resource


@export var id:String
@export var level_name:String
@export var level_difficulty:String
@export var character:CharacterData
@export var rooms:Array[RoomData] = []
@export var shop_loot_table:LootTable
@export var enemy_waves:Array[SpawnerData] = []
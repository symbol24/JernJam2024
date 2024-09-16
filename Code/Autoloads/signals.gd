extends Node

# Game
signal LoadLevel(id:String)


# Rooms
signal RoomReady(room:Room)
signal ToggleDoor(id:String, open:bool)


# Spawning
signal SpawnNextWave()
signal ReturnEnemyToPool(enemy:Enemy2D)


# Character
signal DamageReceived(character:CharacterBody2D, damage:int)
signal HpUpdated(character:BaseCharacterData)
signal CharacterDefeated(character:BaseCharacterData)
signal UpdateCharacterRange(range_percent:float, flat_amount:float)


# UI
signal ToggleControl(id:String, is_visible:bool, from:String)
signal ConstructHP(amount:int)


# Weapons 
signal ReturnProjectileToPool(weapom:Weapon)

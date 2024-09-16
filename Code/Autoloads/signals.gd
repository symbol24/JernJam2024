extends Node

# Game
signal LoadLevel(id:String)
signal InstantiateLevels()


# Rooms
signal RoomReady(room:Room)
signal ToggleDoor(id:String, open:bool)
signal RoomClear()


# Spawning
signal SpawnNextWave()
signal ReturnEnemyToPool(enemy:Enemy2D)


# Character
signal HpUpdated(character:BaseCharacterData)
signal CharacterDefeated(character:BaseCharacterData)
signal UpdateCharacterRange(range_percent:float, flat_amount:float)


# UI
signal ToggleControl(id:String, is_visible:bool, from:String)
signal ConstructHP(amount:int)
signal DmgNbrReturnToPool(dmg_nbr:DamageNumberRTL)
signal CoinsUpdated(coins:int)
signal DamageReceived(character:CharacterBody2D, damage:int, type:Damage.Type, is_critical:bool)


# Weapons 
signal ReturnProjectileToPool(weapom:Weapon)


# Pickups
signal PickupReturnToPool(item:PickupItem)
signal CollectItem(data:PickupData)
signal SpawnLoot(position:Vector2, pickup_data:PickupData)

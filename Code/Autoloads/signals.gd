extends Node

# Game
signal LoadLevel(id:String)
signal InstantiateLevels()
signal RunEnded()


# Camera
signal CameraInPosition()
signal MoveCamera(position:Vector2, time:float)


# Rooms
signal RoomReady(room:Room)
signal ToggleDoor(id:String, open:bool)
signal RoomClear()
signal TransitionToNextRoom()
signal RoomEntered(type:Room.Room_Type)


# Levels
signal LevelReady(level:Level)


# Spawning
signal SpawnNextWave(room:Room)
signal ReturnEnemyToPool(enemy:Enemy2D)
signal InstantiateLevelEnemies(level:Level)


# Character
signal PlayerReady(player:SyCharacterBody2D)
signal HpUpdated(character:BaseCharacterData)
signal CharacterDefeated(character:BaseCharacterData)
signal UpdateCharacterRange(range_percent:float, flat_amount:float)
signal CharacterLevelUpdated(data:BaseCharacterData)
signal RestCharacter()


# UI
signal ToggleControl(id:String, is_visible:bool, from:String)
signal ConstructHP(character:BaseCharacterData)
signal DmgNbrReturnToPool(dmg_nbr:DamageNumberRTL)
signal CoinsUpdated(coins:int)
signal DamageReceived(character:CharacterBody2D, damage:int, type:Damage.Type, is_critical:bool)
signal UpdateUiWithWeapon(weapon:WeaponData)
signal UpdateUiWithTrinket(trinket:TrinketData)
signal ResetPlayerUi()
signal SkipMainMenuMusic()
signal UpdateLevelData(level:Level)
signal ControlSwitch(type:Game.CONTROLS)
signal Shake(time:float, strength:float)


# Weapons 
signal ReturnProjectileToPool(weapom:Weapon)


# Pickups
signal PickupReturnToPool(item:PickupItem)
signal CollectItem(data:PickupData)
signal SpawnLoot(position:Vector2, pickup_data:PickupData)


# Shop
signal ShopItemPurchased(item:ShopItemData)
signal EnterShopItem(item:ShopItemData)
signal ExitShopItem(item:ShopItemData)


# Dialogue
signal DisplayText(text:String)
signal SkipDialogue()
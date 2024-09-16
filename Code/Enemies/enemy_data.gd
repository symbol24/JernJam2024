class_name EnemyData extends BaseCharacterData


@export var path:String = ""
@export var contact_damages:Array[Damage]

var hash_id:int = 0


func set_damage_owner():
	if contact_damages.is_empty(): push_warning("Contact Damages of ", id, " is empty. Is this intended?")
	for each in contact_damages:
		each.set_owner(self)

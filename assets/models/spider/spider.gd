extends Node

@onready var horse_body: MeshInstance3D = $Armature/Skeleton3D/HorseBody
@onready var spider_body: MeshInstance3D = $Armature/Skeleton3D/SpiderBody
@onready var spider_legs: MeshInstance3D = $Armature/Skeleton3D/SpiderLegs

func _ready() -> void:
	$AnimationPlayer.play("Idle")
	_set_mode(Settings.a11y_arachnophobia)
	Settings.a11y_arachnophobia_changed.connect(_set_mode)

func _set_mode(arachnophobia: bool) -> void:
	if arachnophobia:
		spider_body.hide()
		spider_legs.hide()
		horse_body.show()
	else:
		spider_body.show()
		spider_legs.show()
		horse_body.hide()

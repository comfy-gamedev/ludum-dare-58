extends Node


signal freeze_game(freeze: bool)
var frozen: bool = false

func _ready() -> void:
	freeze_game.connect(func (f): frozen = f)

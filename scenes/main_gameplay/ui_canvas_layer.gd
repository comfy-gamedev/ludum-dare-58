extends CanvasLayer

@onready var amount_label: Label = %AmountLabel

var amount: int: set = set_amount

func _ready() -> void:
	Globals.yarn_balls_changed.connect(_on_yarn_balls_changes)

func set_amount(v: int):
	amount = v
	amount_label.text = str(v)

func _on_yarn_balls_changes():
	create_tween().tween_property(self, "amount", Globals.yarn_balls, 0.25)

extends Label

var shake_duration: float = 0.25 # Duration of the shake in seconds
var shake_intensity: float = 15.0 # Maximum distance of the shake
var shake_recovery_factor: float = 0.95 # How quickly the shake fades

func _ready() -> void:
	start_shake()

var _current_shake_intensity: float = 0

func start_shake():
	_current_shake_intensity = shake_intensity
	create_tween().tween_property(self, "position:x", self.position.x - _current_shake_intensity, shake_duration)
	create_tween().tween_property(self, "position:y", self.position.y - _current_shake_intensity, shake_duration)
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", Color.RED, 0.5)
	modulate_tween.tween_callback(modulate_white)
	
func modulate_white():
	create_tween().tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)

func _physics_process(delta):
	if _current_shake_intensity > 0:
		_current_shake_intensity *= (1.0 - shake_recovery_factor * delta)
		create_tween().tween_property(self, "position:x", self.position.x + randf_range(-_current_shake_intensity, _current_shake_intensity), shake_duration)
		create_tween().tween_property(self, "position:y", self.position.y + randf_range(-_current_shake_intensity, _current_shake_intensity), shake_duration)

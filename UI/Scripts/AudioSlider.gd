extends HSlider

@export var bus_name = "Master"

var bus_index = 0
var default_value = 0.0

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	default_value = AudioServer.get_bus_volume_db(bus_index)
	value = db_to_linear(default_value)


func update_db(val):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(val))


func _on_value_changed(value):
	update_db(value)

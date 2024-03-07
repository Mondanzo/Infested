extends Node
class_name BinarySave

const B_TYPE_INT = 0b01
const B_TYPE_FLOAT = 0b10
const B_TYPE_STRING = 0b11

func save_to_binary_file(save_path,variables):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	for variable in variables:
		match typeof(variable):
			TYPE_INT:
				file.store_8(B_TYPE_INT)
				file.store_32(variable)
			TYPE_FLOAT:
				file.store_8(B_TYPE_FLOAT)
				file.store_float(variable)
			TYPE_STRING:
				file.store_8(B_TYPE_STRING)
				file.store_string(variable)

#usage:
#var save_path:String = "res://Saves/SaveGame.bin"
#save_to_binary_file( save_path, [1234, 56.78, "Hello World"] )

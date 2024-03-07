# Virtual base class for all states.
class_name State
extends Node

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent):
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float):
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float):
	pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}):
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	pass


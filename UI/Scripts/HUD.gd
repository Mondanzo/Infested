extends CanvasLayer

var current_ability = null

func update_ability_ui(ability: BaseSkill):
	%AbilityIcon.texture = ability.ability_icon
	%AbilityLabel.text = ability.ability_name
	current_ability = ability


func update_player_health(current_health, max_health):
	%PlayerVitality.value = current_health / max_health
	%PlayerVitality/Label.text = str(current_health) + "/" + str(max_health) + " hp"


func update_player_fragments(new_fragments):
	%FragmentsCounter.text = str(new_fragments)


func _process(delta):
	%AbilityContainer.visible = current_ability != null
	
	if current_ability:
		%CooldownCounter.value = 1 - current_ability.CooldownPercentage()
		


func _on_player_ability_changed(ability):
	update_ability_ui(ability)


func _on_player_vitality_changed(current_hp, max_health):
	update_player_health(current_hp, max_health)

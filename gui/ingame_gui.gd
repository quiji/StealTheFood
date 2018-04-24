extends CanvasLayer

enum GuiTypes {INCOGNITO_MODE, ALARM_MODE}

var mode_change_completed_method = null
var current_mode = INCOGNITO_MODE

var buggies = 0

func _ready():
	
	$enemy_indicator.connect("finished_showing", self, "on_finished_showing_enemy_planes")

func mode_change_completed_callback(method_name):
	if get_parent().has_method(method_name):
		mode_change_completed_method = method_name

func change_mode(mode):
	get_tree().paused = true
	current_mode = mode
	match mode:
		INCOGNITO_MODE:
			hide_buggies_count()
			get_tree().paused = false
			if mode_change_completed_method != null:
				get_parent().call(mode_change_completed_method, current_mode)

		ALARM_MODE:
			show_buggies_count()

func on_finished_showing_enemy_planes():
	get_tree().paused = false
	if mode_change_completed_method != null:
		get_parent().call(mode_change_completed_method, current_mode)

func set_buggies(val):
	buggies = val

func show_buggies_count():
	$enemy_indicator.show_count(buggies)

func hide_buggies_count():
	pass

func buggie_down():
	$enemy_indicator.buggie_down()

func set_shields(n):
	$armor_indicator.set_shield_count(n)

func add_shields(n):
	$armor_indicator.add_shields(n)

func remove_shields(n):
	$armor_indicator.remove_shields(n)

func update_score(apple_count):
	$ApplePoints.text = "Apple Points: " + str(apple_count)

func pause_menu(val):
	if val:
		$pause_menu.show_menu()

func pause_menu_hidden():
	get_tree().paused = false
	get_parent().pause_menu_hidden()
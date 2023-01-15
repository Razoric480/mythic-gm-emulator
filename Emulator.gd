extends Control


const Entry := preload("res://Entry.tscn")


const LIKELIHOODS := [
	[[0, -20, 77], [0, 0, 81], [0, 0, 81], [1, 5, 82], [1, 5, 82], [2, 10, 83], [3, 15, 84], [5, 25, 86], [10, 50, 91]],
	[[0, 0, 81], [1, 5, 82], [1, 5, 82], [2, 10, 83], [3, 15, 84], [5, 25, 86], [7, 35, 88], [10, 50, 91], [15, 75, 96]],
	[[1, 5, 82], [1, 5, 82], [2, 10, 83], [3, 15, 84], [5, 25, 86], [9, 45, 90], [10, 50, 91], [13, 65, 94], [16, 85, 97]],
	[[1, 5, 82], [2, 10, 83], [3, 15, 84], [4, 20, 85], [7, 35, 88], [10, 50, 91], [11, 55, 92], [15, 75, 96], [18, 90, 99]],
	[[2, 10, 83], [3, 15, 84], [5, 25, 86], [7, 35, 88], [10, 50, 91], [13, 65, 94], [15, 75, 96], [16, 85, 97], [19, 95, 100]],
	[[4, 20, 85], [5, 25, 86], [9, 45, 90], [10, 50, 91], [13, 65, 94], [16, 80, 97], [16, 85, 97], [18, 90, 99], [19, 95, 100]],
	[[5, 25, 86], [7, 35, 88], [10, 50, 91], [11, 55, 92], [15, 75, 96], [16, 85, 97], [18, 90, 99], [19, 95, 100], [20, 100, 0]],
	[[9, 45, 90], [10, 50, 91], [13, 65, 94], [15, 75, 96], [16, 85, 97], [18, 90, 99], [19, 95, 100], [19, 95, 100], [21, 105, 0]],
	[[10, 50, 91], [11, 55, 92], [15, 75, 96], [16, 80, 97], [18, 90, 99], [19, 95, 100], [19, 95, 100], [20, 100, 0], [23, 115, 0]],
	[[11, 55, 92], [13, 65, 94], [16, 80, 97], [16, 85, 97], [18, 90, 99], [19, 95, 100], [19, 95, 100], [22, 110, 0], [25, 125, 0]],
	[[16, 80, 97], [16, 85, 97], [18, 90, 99], [19, 95, 100], [19, 95, 100], [20, 100, 0], [20, 100, 0], [26, 130, 0], [26, 145, 0]],
]

const RANDOM_EVENT_TYPES := [
	"Remote Event", "NPC Action", "New NPC", "Move Towards Thread", "Move Away From Thread",
	"Close Thread", "PC Negative", "PC Positive", "Ambiguous Event", "NPC Negative", "NPC Positive",
]

const THREAD_EVENTS := ["Move Towards Thread", "Move Away From Thread", "Close Thread",]

const NPC_EVENTS := ["NPC Action", "NPC Negative", "NPC Positive",]

const ACTIONS := [
	"Attainment", "Starting", "Neglect", "Fight", "Recruit", "Triumph", "Violate", "Oppose", "Malice", "Communicate",
	"Persecute", "Increase", "Decrease", "Abandon", "Gratify", "Inquire", "Antagonise", "Move", "Waste", "Truce",
	"Release", "Befriend", "Judge", "Desert", "Dominate", "Procrastinate", "Praise", "Separate", "Take", "Break",
	"Heal", "Delay", "Stop", "Lie", "Return", "Immitate", "Struggle", "Inform", "Bestow", "Postpone", "Expose",
	"Haggle", "Imprison", "Release", "Celebrate", "Develop", "Travel", "Block", "Harm", "Debase", "Overindulge",
	"Adjourn", "Adversity", "Kill", "Disrupt", "Usurp", "Create", "Betray", "Agree", "Abuse", "Oppress",
	"Inspect", "Ambush", "Spy", "Attach", "Carry", "Open", "Carelessness", "Ruin", "Extravagance", "Trick",
	"Arrive", "Propose", "Divide", "Refuse", "Mistrust", "Deceive", "Cruelty", "Intolerance", "Trust",
	"Excitement", "Activity", "Assist", "Care", "Negligence", "Passion", "Work hard", "Control", "Attract",
	"Failure", "Pursue", "Vengeance", "Proceedings", "Dispute", "Punish", "Guide", "Transform", "Overthrow",
	"Oppress", "Change",
]

const SUBJECTS := [
	"Goals", "Dreams", "Environment", "Outside", "Inside", "Reality", "Allies", "Enemies", "Evil", "Good",
	"Emotions", "Opposition", "War", "Peace", "The innocent", "Love", "The spiritual", "The intellectual",
	"New ideas", "Joy", "Messages", "Energy", "Balance", "Tension", "Friendship", "The physical", "A project",
	"Pleasures", "Pain", "Possessions", "Benefits", "Plans", "Lies", "Expectations", "Legal matters", "Bureaucracy",
	"Business", "A path", "News", "Exterior factors", "Advice", "A plot", "Competition", "Prison", "Illness",
	"Food", "Attention", "Success", "Failure", "Travel", "Jealousy", "Dispute", "Home", "Investment", "Suffering",
	"Wishes", "Tactics", "Stalemate", "Randomness", "Misfortune", "Death", "Disruption", "Power", "A burden",
	"Intrigues", "Fears", "Ambush", "Rumor", "Wounds", "Extravagance", "A representative", "Adversities",
	"Opulence", "Liberty", "Military", "The mundane", "Trials", "Masses", "Vehicle", "Art", "Victory",
	"Dispute", "Riches", "Status quo", "Technology", "Hope", "Magic", "Illusions", "Portals", "Danger", "Weapons",
	"Animals", "Weather", "Elements", "Nature", "The public", "Leadership", "Fame", "Anger", "Information",
]

var rng := RandomNumberGenerator.new()
var chaos_factor_idx := 4
var logs := []
var current_idx := 0

onready var add_scene_button: Button = $"%AddSceneButton"
onready var add_comment_button: Button = $"%AddCommentButton"
onready var answers: HBoxContainer = $"%Answers"
onready var question_line: LineEdit = $"%QuestionLine"
onready var log_box: RichTextLabel = $"%LogBox"
onready var comment_line: LineEdit = $"%CommentLine"
onready var lower_chaos: Button = $"%LowerChaos"
onready var chaos_factor: Label = $"%ChaosFactor"
onready var increase_chaos: Button = $"%IncreaseChaos"
onready var threads_list: VBoxContainer = $"%ThreadsList"
onready var characters_list: VBoxContainer = $"%CharactersList"
onready var scene_line: LineEdit = $"%SceneLine"
onready var log_scroll_container: ScrollContainer = $"%LogScrollContainer"
onready var add_character_button: Button = $"%AddCharacterButton"
onready var add_thread_button: Button = $"%AddThreadButton"
onready var scenes_button: MenuButton = $"%ScenesButton"
onready var save_campaign_button: Button = $"%SaveCampaignButton"
onready var campaign_select_button: MenuButton = $"%CampaignSelectButton"
onready var campaign_name: LineEdit = $"%CampaignName"
onready var new_campaign_button: Button = $"%NewCampaignButton"



func _ready() -> void:
	rng.randomize()
	
	var _err := answers.connect("answer_pressed", self, "_on_Answers_pressed")
	_err = add_scene_button.connect("pressed", self, "_on_AddScene_pressed")
	_err = add_comment_button.connect("pressed", self, "_on_AddComment_pressed")
	_err = question_line.connect("text_changed", self, "_on_QuestionLine_changed")
	_err = lower_chaos.connect("pressed", self, "_on_LowerChaos_pressed")
	_err = increase_chaos.connect("pressed", self, "_on_IncreaseChaos_pressed")
	_err = comment_line.connect("text_changed", self, "_on_CommentLine_changed")
	_err = scene_line.connect("text_changed", self, "_on_SceneLine_changed")
	_err = add_character_button.connect("pressed", self, "_on_AddCharacter_pressed")
	_err = add_thread_button.connect("pressed", self, "_on_AddThread_pressed")
	_err = scenes_button.get_popup().connect("index_pressed", self, "_on_scene_index_pressed")
	_err = save_campaign_button.connect("pressed", self, "_on_save_campaign_button_pressed")
	_err = campaign_select_button.get_popup().connect("index_pressed", self, "_on_campaign_select_button_pressed")
	_err = campaign_name.connect("text_changed", self, "_on_campaign_name_text_changed")
	_err = new_campaign_button.connect("pressed", self, "_on_new_campaign_pressed")
	
	var dir := Directory.new()
	_err = dir.open("user://")
	_err = dir.list_dir_begin(true)
	while true:
		var next := dir.get_next()
		if next.empty():
			break
		
		if not next.get_extension() == "json":
			continue
		var next_campaign_name := next.trim_suffix(".json")
		campaign_select_button.get_popup().add_item(next_campaign_name)


func _resolve_random_event() -> void:
	var i := rng.randi_range(0, RANDOM_EVENT_TYPES.size()-1)
	var random_event_type: String = RANDOM_EVENT_TYPES[i]
	while (random_event_type in NPC_EVENTS and characters_list.get_child_count() == 0) or (random_event_type in THREAD_EVENTS and threads_list.get_child_count() == 0):
		i = rng.randi_range(0, RANDOM_EVENT_TYPES.size()-1)
		random_event_type = RANDOM_EVENT_TYPES[i]
	
	var output := "\n%s" % [random_event_type]
	if random_event_type in NPC_EVENTS:
		var random_character: String = characters_list.get_child(rng.randi_range(0, characters_list.get_child_count()-1)).data
		output += " involving %s" % [random_character]
	elif random_event_type in THREAD_EVENTS:
		var random_thread: String = threads_list.get_child(rng.randi_range(0, threads_list.get_child_count()-1)).data
		output += " about %s" % [random_thread]
	
	output += "\n\t"
	var action_idx := rng.randi_range(0, 99)
	var subject_idx := rng.randi_range(0, 99)
	var action: String = ACTIONS[action_idx]
	var subject: String = SUBJECTS[subject_idx]
	output += "Context: %s %s\n" % [action, subject]
	
	log_box.bbcode_text += output
	_update_scroll()


func _update_scroll() -> void:
	log_scroll_container.scroll_vertical = int(log_scroll_container.get_v_scrollbar().max_value)


func _on_campaign_name_text_changed(text: String) -> void:
	save_campaign_button.disabled = text.empty()


func _on_new_campaign_pressed() -> void:
	logs.clear()
	log_box.bbcode_text = ""
	scenes_button.get_popup().clear()
	campaign_name.text = ""
	for child in characters_list.get_children():
		child.queue_free()
	for child in threads_list.get_children():
		child.queue_free()


func _on_save_campaign_button_pressed() -> void:
	logs[current_idx] = log_box.bbcode_text
	
	var file := File.new()
	var _err := file.open("user://%s.json" % [campaign_name.text], File.WRITE)
	file.store_line(JSON.print(logs, "\t"))
	file.close()
	
	for select in campaign_select_button.get_popup().get_item_count():
		if campaign_select_button.get_popup().get_item_text(select) == campaign_name.text:
			return
	campaign_select_button.get_popup().add_item(campaign_name.text)
	
	_err = file.open("user://%s-chaos" % [campaign_name.text], File.WRITE)
	file.store_line(str(chaos_factor_idx + 1))
	file.close()
	
	_err = file.open("user://%s-lists" % [campaign_name.text], File.WRITE)
	var output := {"characters": [], "threads": []}
	for child in characters_list.get_children():
		output.characters.push_back(child.data)
	for child in threads_list.get_children():
		output.threads.push_back(child.data)
	file.store_line(JSON.print(output, "\t"))
	file.close()


func _on_campaign_select_button_pressed(index: int) -> void:
	var file := File.new()
	var _err := file.open("user://%s.json" % [campaign_select_button.get_popup().get_item_text(index)], File.READ)
	var json_data := file.get_as_text()
	file.close()
	
	scenes_button.get_popup().clear()
	logs = JSON.parse(json_data).result
	for entry in logs:
		var starting_line: String = entry.split("\n")[0]
		log_box.bbcode_text = starting_line
		starting_line = log_box.text
		log_box.bbcode_text = ""
		scenes_button.get_popup().add_item(starting_line)

	current_idx = scenes_button.get_popup().get_item_count() - 1
	log_box.bbcode_text = logs[current_idx]
	log_scroll_container.scroll_vertical = int(log_scroll_container.get_v_scrollbar().max_value)
	
	campaign_name.text = campaign_select_button.get_popup().get_item_text(index)
	save_campaign_button.disabled = false
	
	_err = file.open("user://%s-chaos" % [campaign_select_button.get_popup().get_item_text(index)], File.READ)
	chaos_factor_idx = file.get_line().to_int() - 1
	file.close()
	
	chaos_factor.text = str(chaos_factor_idx + 1)
	
	_err = file.open("user://%s-lists" % [campaign_select_button.get_popup().get_item_text(index)], File.READ)
	json_data = file.get_as_text()
	file.close()
	
	for entry in characters_list.get_children() + threads_list.get_children():
		entry.queue_free()
	
	var lists: Dictionary = JSON.parse(json_data).result
	for character in lists.characters:
		var entry := Entry.instance()
		characters_list.add_child(entry)
		entry.data = character
	for thread in lists.threads:
		var entry := Entry.instance()
		threads_list.add_child(entry)
		entry.data = thread


func _on_CommentLine_changed(text: String) -> void:
	add_comment_button.disabled =  text.empty()


func _on_SceneLine_changed(text: String) -> void:
	add_scene_button.disabled = text.empty()


func _on_LowerChaos_pressed() -> void:
	chaos_factor_idx = int(max(chaos_factor_idx - 1, 0))
	chaos_factor.text = str(chaos_factor_idx + 1)


func _on_IncreaseChaos_pressed() -> void:
	chaos_factor_idx = int(min(chaos_factor_idx + 1, 8))
	chaos_factor.text = str(chaos_factor_idx + 1)


func _on_Answers_pressed(likelihood: int) -> void:
	var thresholds: Array = LIKELIHOODS[likelihood][chaos_factor_idx]
	var extreme_low: int = thresholds[0]
	var extreme_high: int = thresholds[2]
	var threshold: int = thresholds[1]

	var random_number := rng.randi_range(1, 100)
	
	var text := question_line.text
	question_line.clear()
	
	log_box.bbcode_text += "\n%s: " % [text]
	
	var answer := ""
	if random_number <= extreme_low:
		answer = "Exceptional Yes"
		log_box.bbcode_text += "[color=#00ffff]"
	elif random_number < threshold:
		answer = "Yes"
		log_box.bbcode_text += "[color=#90EE90]"
	elif random_number >= extreme_high:
		answer = "Exceptional No"
		log_box.bbcode_text += "[color=#ff0000]"
	else:
		answer = "No"
		log_box.bbcode_text += "[color=#DC143C]"
	
	log_box.bbcode_text += "%s (%s)" % [answer, random_number]
	log_box.bbcode_text += "[/color]"
	
	var tens := int(random_number / 10.0)
	
	if tens > chaos_factor_idx + 1:
		return
	
	var ones := random_number - tens * 10
	
	if tens == ones:
		log_box.bbcode_text += "[color=#ffff00] + Random Event[/color]"
		_resolve_random_event()
	
	_update_scroll()


func _on_AddScene_pressed() -> void:
	if current_idx < logs.size():
		logs[current_idx] = log_box.bbcode_text
	
	log_box.bbcode_text = ""
	var text := scene_line.text
	scene_line.clear()
	var i := rng.randi_range(1, 10)
	if i <= chaos_factor_idx + 1:
		var output := "%s" % [text]
		if i % 2 == 0:
			log_box.bbcode_text += "[s]"
		else:
			output += "\n... BUT the premise is altered (%s)." % [i]
		log_box.bbcode_text += output + "\n"
		if i % 2 == 0:
			log_box.bbcode_text += "[/s]"
			log_box.bbcode_text += "\n... BUT the setup is interrupted. (%s)" % [i]
			_resolve_random_event()
	else:
		log_box.bbcode_text += text + "\n\n"
		
	_update_scroll()
	scenes_button.get_popup().add_item(text)
	logs.push_back(log_box.bbcode_text)
	current_idx = logs.size() - 1


func _on_AddComment_pressed() -> void:
	var text := comment_line.text
	comment_line.clear()
	log_box.bbcode_text += "\n%s" % [text]
	_update_scroll()


func _on_QuestionLine_changed(_text: String) -> void:
	answers.toggle_buttons(not _text.empty())


func _on_AddCharacter_pressed() -> void:
	var instance := Entry.instance()
	characters_list.add_child(instance)
	instance.edit_mode()


func _on_AddThread_pressed() -> void:
	var instance := Entry.instance()
	threads_list.add_child(instance)
	instance.edit_mode()


func _on_scene_index_pressed(idx: int) -> void:
	logs[current_idx] = log_box.bbcode_text
	log_box.bbcode_text = logs[idx]
	current_idx = idx

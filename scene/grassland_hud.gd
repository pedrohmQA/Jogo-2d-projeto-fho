extends CanvasLayer

@onready var panel_label   = $HBoxContainer/Panel/Label
@onready var battery_label = $HBoxContainer/Battery/Label
@onready var cable_label   = $HBoxContainer/Cable/Label

func _ready():
	update_counts()
	set_process(true)

func _process(_delta):
	update_counts()

func update_counts():
	panel_label.text   = "x" + str(QuestState.panels)
	battery_label.text = "x" + str(QuestState.batteries)
	cable_label.text   = "x" + str(QuestState.cables)

extends Control


var insim := InSim.new()


func _ready() -> void:
	add_child(insim)
	connect_signals()
	initialize_insim()


func _exit_tree() -> void:
	insim.close()


func connect_signals() -> void:
	var _discard := insim.isp_ver_received.connect(_on_ver_received)


func initialize_insim() -> void:
	var init_data := InSimInitializationData.new()
	init_data.flags |= InSim.InitFlag.ISF_LOCAL | InSim.InitFlag.ISF_MSO_COLS \
			| InSim.InitFlag.ISF_NLP | InSim.InitFlag.ISF_MCI | InSim.InitFlag.ISF_CON \
			| InSim.InitFlag.ISF_OBH | InSim.InitFlag.ISF_HLV | InSim.InitFlag.ISF_AXM_LOAD \
			| InSim.InitFlag.ISF_AXM_EDIT| InSim.InitFlag.ISF_REQ_JOIN
	init_data.interval = 500
	init_data.i_name = "GIS Tests"
	insim.initialize(init_data)


func print_packet(packet: InSimPacket) -> void:
	print("%s: %s" % [InSim.Packet.keys()[packet.type], packet.get_dictionary()])


func _on_ver_received(packet: InSimVERPacket) -> void:
	print_packet(packet)

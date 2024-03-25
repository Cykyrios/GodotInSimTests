extends MarginContainer


const NON_STANDARD_PACKETS := [InSim.Packet.ISP_TINY,
		InSim.Packet.ISP_SMALL, InSim.Packet.ISP_TTC]
const PACKET_TESTED_COLOR := Color(0.2, 1, 0.2)

var insim := InSim.new()

@onready var standard_packets_vbox: VBoxContainer = %StandardPacketsVBox
@onready var tiny_packets_vbox: VBoxContainer = %TinyPacketsVBox
@onready var small_packets_vbox: VBoxContainer = %SmallPacketsVBox
@onready var ttc_packets_vbox: VBoxContainer = %TTCPacketsVBox


func _ready() -> void:
	add_child(insim)
	add_buttons()
	connect_signals()
	initialize_insim()


func _exit_tree() -> void:
	insim.close()


func add_buttons() -> void:
	for i in InSim.Packet.size():
		var packet_type := InSim.Packet.values()[i] as InSim.Packet
		var button := Button.new()
		button.text = InSim.Packet.keys()[i]
		var _discard := button.pressed.connect(_on_button_pressed.bind(packet_type))
		var packet := create_packet(packet_type)
		if not packet.sendable or packet_type in NON_STANDARD_PACKETS:
			button.disabled = true
		standard_packets_vbox.add_child(button)
	for i in InSim.Tiny.size():
		var subtype := InSim.Tiny.values()[i] as InSim.Tiny
		var button := Button.new()
		button.text = InSim.Tiny.keys()[i]
		var _discard := button.pressed.connect(_on_button_pressed.bind(InSim.Packet.ISP_TINY, i))
		var packet := create_packet(InSim.Packet.ISP_TINY, subtype)
		if not packet.sendable:
			button.disabled = true
		tiny_packets_vbox.add_child(button)
	for i in InSim.Small.size():
		var subtype := InSim.Small.values()[i] as InSim.Small
		var button := Button.new()
		button.text = InSim.Small.keys()[i]
		var _discard := button.pressed.connect(_on_button_pressed.bind(InSim.Packet.ISP_SMALL, i))
		var packet := create_packet(InSim.Packet.ISP_SMALL, subtype)
		if not packet.sendable:
			button.disabled = true
		small_packets_vbox.add_child(button)
	for i in InSim.TTC.size():
		var subtype := InSim.TTC.values()[i] as InSim.TTC
		var button := Button.new()
		button.text = InSim.TTC.keys()[i]
		var _discard := button.pressed.connect(_on_button_pressed.bind(InSim.Packet.ISP_TTC, i))
		var packet := create_packet(InSim.Packet.ISP_TTC, subtype)
		if not packet.sendable:
			button.disabled = true
		ttc_packets_vbox.add_child(button)


func connect_signals() -> void:
	var _discard := insim.packet_received.connect(_on_packet_received)
	_discard = insim.packet_sent.connect(_on_packet_sent)


func create_packet(type: InSim.Packet, subtype := -1) -> InSimPacket:
	var packet: InSimPacket = null
	match type:
		InSim.Packet.ISP_NONE:
			packet = InSimPacket.new()
		InSim.Packet.ISP_ISI:
			packet = InSimISIPacket.new()
		InSim.Packet.ISP_VER:
			packet = InSimVERPacket.new()
		InSim.Packet.ISP_TINY:
			packet = InSimTinyPacket.new(1, subtype as InSim.Tiny)
		InSim.Packet.ISP_SMALL:
			packet = InSimSmallPacket.new(1, subtype as InSim.Small)
		InSim.Packet.ISP_STA:
			packet = InSimSTAPacket.new()
		InSim.Packet.ISP_SCH:
			packet = InSimSCHPacket.new()
		InSim.Packet.ISP_SFP:
			packet = InSimSFPPacket.new()
		InSim.Packet.ISP_SCC:
			packet = InSimSCCPacket.new()
		InSim.Packet.ISP_CPP:
			packet = InSimCPPPacket.new()
		InSim.Packet.ISP_ISM:
			packet = InSimISMPacket.new()
		InSim.Packet.ISP_MSO:
			packet = InSimMSOPacket.new()
		InSim.Packet.ISP_III:
			packet = InSimIIIPacket.new()
		InSim.Packet.ISP_MST:
			packet = InSimMSTPacket.new()
		InSim.Packet.ISP_MTC:
			packet = InSimMTCPacket.new()
		InSim.Packet.ISP_MOD:
			packet = InSimMODPacket.new()
		InSim.Packet.ISP_VTN:
			packet = InSimVTNPacket.new()
		InSim.Packet.ISP_RST:
			packet = InSimRSTPacket.new()
		InSim.Packet.ISP_NCN:
			packet = InSimNCNPacket.new()
		InSim.Packet.ISP_CNL:
			packet = InSimCNLPacket.new()
		InSim.Packet.ISP_CPR:
			packet = InSimCPRPacket.new()
		InSim.Packet.ISP_NPL:
			packet = InSimNPLPacket.new()
		InSim.Packet.ISP_PLP:
			packet = InSimPLPPacket.new()
		InSim.Packet.ISP_PLL:
			packet = InSimPLLPacket.new()
		InSim.Packet.ISP_LAP:
			packet = InSimLAPPacket.new()
		InSim.Packet.ISP_SPX:
			packet = InSimSPXPacket.new()
		InSim.Packet.ISP_PIT:
			packet = InSimPITPacket.new()
		InSim.Packet.ISP_PSF:
			packet = InSimPSFPacket.new()
		InSim.Packet.ISP_PLA:
			packet = InSimPLAPacket.new()
		InSim.Packet.ISP_CCH:
			packet = InSimCCHPacket.new()
		InSim.Packet.ISP_PEN:
			packet = InSimPENPacket.new()
		InSim.Packet.ISP_TOC:
			packet = InSimTOCPacket.new()
		InSim.Packet.ISP_FLG:
			packet = InSimFLGPacket.new()
		InSim.Packet.ISP_PFL:
			packet = InSimPFLPacket.new()
		InSim.Packet.ISP_FIN:
			packet = InSimFINPacket.new()
		InSim.Packet.ISP_RES:
			packet = InSimRESPacket.new()
		InSim.Packet.ISP_REO:
			packet = InSimREOPacket.new()
		InSim.Packet.ISP_NLP:
			packet = InSimNLPPacket.new()
		InSim.Packet.ISP_MCI:
			packet = InSimMCIPacket.new()
		InSim.Packet.ISP_MSX:
			packet = InSimMSXPacket.new()
		InSim.Packet.ISP_MSL:
			packet = InSimMSLPacket.new()
		InSim.Packet.ISP_CRS:
			packet = InSimCRSPacket.new()
		InSim.Packet.ISP_BFN:
			packet = InSimBFNPacket.new()
		InSim.Packet.ISP_AXI:
			packet = InSimAXIPacket.new()
		InSim.Packet.ISP_AXO:
			packet = InSimAXOPacket.new()
		InSim.Packet.ISP_BTN:
			packet = InSimBTNPacket.new()
		InSim.Packet.ISP_BTC:
			packet = InSimBTCPacket.new()
		InSim.Packet.ISP_BTT:
			packet = InSimBTTPacket.new()
		InSim.Packet.ISP_RIP:
			packet = InSimRIPPacket.new()
		InSim.Packet.ISP_SSH:
			packet = InSimSSHPacket.new()
		InSim.Packet.ISP_CON:
			packet = InSimCONPacket.new()
		InSim.Packet.ISP_OBH:
			packet = InSimOBHPacket.new()
		InSim.Packet.ISP_HLV:
			packet = InSimHLVPacket.new()
		InSim.Packet.ISP_PLC:
			packet = InSimPLCPacket.new()
		InSim.Packet.ISP_AXM:
			packet = InSimAXMPacket.new()
		InSim.Packet.ISP_ACR:
			packet = InSimACRPacket.new()
		InSim.Packet.ISP_HCP:
			packet = InSimHCPPacket.new()
		InSim.Packet.ISP_NCI:
			packet = InSimNCIPacket.new()
		InSim.Packet.ISP_JRR:
			packet = InSimJRRPacket.new()
		InSim.Packet.ISP_UCO:
			packet = InSimUCOPacket.new()
		InSim.Packet.ISP_OCO:
			packet = InSimOCOPacket.new()
		InSim.Packet.ISP_TTC:
			packet = InSimTTCPacket.new(1, subtype as InSim.TTC)
		InSim.Packet.ISP_SLC:
			packet = InSimSLCPacket.new()
		InSim.Packet.ISP_CSC:
			packet = InSimCSCPacket.new()
		InSim.Packet.ISP_CIM:
			packet = InSimCIMPacket.new()
		InSim.Packet.ISP_MAL:
			packet = InSimMALPacket.new()
		InSim.Packet.ISP_PLH:
			packet = InSimPLHPacket.new()
	return packet


func initialize_insim() -> void:
	var init_data := InSimInitializationData.new()
	init_data.flags |= InSim.InitFlag.ISF_LOCAL | InSim.InitFlag.ISF_MSO_COLS \
			| InSim.InitFlag.ISF_NLP | InSim.InitFlag.ISF_MCI | InSim.InitFlag.ISF_CON \
			| InSim.InitFlag.ISF_OBH | InSim.InitFlag.ISF_HLV | InSim.InitFlag.ISF_AXM_LOAD \
			| InSim.InitFlag.ISF_AXM_EDIT| InSim.InitFlag.ISF_REQ_JOIN
	init_data.interval = 500
	init_data.i_name = "GIS Tests"
	insim.initialize(init_data)


func mark_tested_packet_button(packet: InSimPacket) -> void:
	var button: Button = null
	match packet.type:
		InSim.Packet.ISP_TINY:
			button = tiny_packets_vbox.get_child((packet as InSimTinyPacket).sub_type + 1) as Button
			button.modulate = PACKET_TESTED_COLOR
		InSim.Packet.ISP_SMALL:
			button = small_packets_vbox.get_child((packet as InSimSmallPacket).sub_type + 1) as Button
			button.modulate = PACKET_TESTED_COLOR
		InSim.Packet.ISP_TTC:
			button = ttc_packets_vbox.get_child((packet as InSimTTCPacket).sub_type + 1) as Button
			button.modulate = PACKET_TESTED_COLOR
		_:
			button = standard_packets_vbox.get_child(packet.type + 1) as Button
			button.modulate = PACKET_TESTED_COLOR


func print_packet(packet: InSimPacket) -> void:
	print("%s: %s" % [InSim.Packet.keys()[packet.type], packet.get_dictionary()])


func test_BFN_packet() -> void:
	var packet := InSimBFNPacket.new()
	packet.subtype = InSim.ButtonFunction.BFN_DEL_BTN
	packet.ucid = 0
	packet.click_id = 1
	insim.send_packet(packet)


func test_BTN_packet() -> void:
	var packet := InSimBTNPacket.new()
	packet.ucid = 0
	packet.click_id = 1
	packet.button_style = InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_RIGHT
	packet.left = 100
	packet.top = 100
	packet.width = 30
	packet.height = 10
	packet.text = "Test ^1button"
	insim.send_packet(packet)


func test_CPP_packet() -> void:
	var packet := InSimCPPPacket.new()
	packet.view_plid = 255
	packet.ingame_cam = 255
	packet.gis_position = Vector3(20, 0, 2)
	packet.gis_angles = Vector3(deg_to_rad(-20), deg_to_rad(-150), deg_to_rad(20))
	packet.fov = 70
	packet.gis_time = 0.5
	packet.flags = InSim.State.ISS_SHIFTU | InSim.State.ISS_SHIFTU_FOLLOW
	insim.send_packet(packet)
	await get_tree().create_timer(1).timeout
	packet = InSimCPPPacket.new()
	packet.view_plid = 255
	packet.ingame_cam = 255
	packet.gis_position = Vector3(20, 0, 20)
	packet.gis_angles = Vector3(deg_to_rad(0), deg_to_rad(0), deg_to_rad(50))
	packet.gis_time = 1.5
	packet.flags = InSim.State.ISS_SHIFTU | InSim.State.ISS_SHIFTU_FOLLOW
	insim.send_packet(packet)
	await get_tree().create_timer(2).timeout


func test_HCP_packet() -> void:
	var packet := InSimHCPPacket.new()
	packet.car_hcp[InSim.Car.CAR_XFG].h_tres = 50
	insim.send_packet(packet)


func test_JRR_packet() -> void:
	var packet := InSimJRRPacket.new()
	packet.player_id = 1
	packet.action = InSim.JRRAction.JRR_RESET_NO_REPAIR
	packet.start_pos.flags |= 0x80
	packet.start_pos.gis_position = Vector3(randf_range(-2000, 2000), randf_range(-2000, 2000), 50)
	insim.send_packet(packet)


func test_MAL_packet() -> void:
	var packet := InSimMALPacket.new()
	packet.num_mods = 0
	insim.send_packet(packet)


func test_MSL_packet() -> void:
	var packet := InSimMSLPacket.new()
	packet.msg = "This is a ^1TEST^8 message - ^1日本語^0, etc."
	insim.send_packet(packet)


func test_MST_packet() -> void:
	var packet := InSimMSTPacket.new()
	packet.msg = "This is a ^2TEST^8 message - ^7日本語^9, etc."
	insim.send_packet(packet)


func test_MSX_packet() -> void:
	var packet := InSimMSXPacket.new()
	packet.msg = "This is a ^3TEST^8 message - ^9日本語^6, etc."
	insim.send_packet(packet)


func test_MTC_packet() -> void:
	var packet := InSimMTCPacket.new()
	packet.ucid = 255
	packet.text = "This is a test, ^1with ^2colors ^3and ^4日本語 ^5too^9.^7^^"
	insim.send_packet(packet)


func test_OCO_packet() -> void:
	for i in 4:
		var packet := InSimOCOPacket.new()
		packet.oco_action = InSim.OCOAction.OCO_LIGHTS_SET
		packet.index = 240
		packet.identifier = 0
		packet.data = randi_range(0, 16)
		insim.send_packet(packet)
		await get_tree().create_timer(0.5).timeout


func test_PLC_packet() -> void:
	var packet := InSimPLCPacket.new()
	packet.ucid = 0
	packet.cars = InSim.Car.CAR_XRG
	insim.send_packet(packet)


func test_PLH_packet() -> void:
	var packet := InSimPLHPacket.new()
	packet.req_i = 1
	packet.nump = 1
	var hcap := PlayerHandicap.new()
	hcap.player_id = 2
	hcap.flags |= 2
	hcap.h_tres = 50
	packet.hcaps.append(hcap)
	insim.send_packet(packet)


func test_RIP_packet() -> void:
	var packet := InSimRIPPacket.new()
	packet.req_i = 1
	packet.replay_name = "temp_spr"
	packet.gis_c_time = 100
	insim.send_packet(packet)


func test_SCC_packet() -> void:
	var packet := InSimSCCPacket.new()
	packet.view_plid = 0
	packet.ingame_cam = InSim.View.VIEW_CAM
	insim.send_packet(packet)


func test_SCH_packet() -> void:
	# There seems to be an issue with this packet on LFS's side: changing view with V works fine,
	# but H does not toggle message history, I does not switch ignition, L does not turn pit limiter on, etc.
	# Sending 9 does work for hazard lights.
	var packet := InSimSCHPacket.new()
	packet.char_byte = "V".unicode_at(0)
	packet.flags = 0
	insim.send_packet(packet)
	packet = InSimSCHPacket.new()
	packet.char_byte = "H".unicode_at(0)
	packet.flags = 0
	insim.send_packet(packet)
	packet = InSimSCHPacket.new()
	packet.char_byte = "9".unicode_at(0)
	packet.flags = 0
	insim.send_packet(packet)


func test_SFP_packet() -> void:
	var packet := InSimSFPPacket.new()
	packet.flag = InSim.State.ISS_SHOW_2D
	packet.off_on = 0
	insim.send_packet(packet)


func test_SMALL_packet(subtype: InSim.Small) -> void:
	var value := 0
	match subtype:
		InSim.Small.SMALL_SSP:
			value = 500
		InSim.Small.SMALL_SSG:
			value = 500
		InSim.Small.SMALL_TMS:
			value = randi_range(0, 1)
		InSim.Small.SMALL_STP:
			value = 50
		InSim.Small.SMALL_NLI:
			value = 1000
		InSim.Small.SMALL_ALC:
			value = InSim.Car.CAR_XRT
		InSim.Small.SMALL_LCS:
			for loop in 8:
				insim.send_packet(InSimSmallPacket.new(0, subtype, randi_range(0, 0xffffff)))
				await get_tree().create_timer(0.25).timeout
			insim.send_packet(InSimSmallPacket.new(0, subtype, 0x1f))
			return
		InSim.Small.SMALL_LCL:
			for loop in 8:
				insim.send_packet(InSimSmallPacket.new(0, subtype, randi_range(0, 0xffffff)))
				await get_tree().create_timer(0.25).timeout
			insim.send_packet(InSimSmallPacket.new(0, subtype, 0x7f))
			return
	insim.send_packet(InSimSmallPacket.new(1, subtype, value))


func test_SSH_packet() -> void:
	var packet := InSimSSHPacket.new()
	packet.req_i = 1
	packet.screenshot_name = "super_test"
	insim.send_packet(packet)


func test_TINY_packet(subtype: InSim.Tiny) -> void:
	# TINY_CLOSE not included in sendables as it is handled specifically through InSim.close()
	var sendable_tiny_packets: Array[InSim.Tiny] = [
		InSim.Tiny.TINY_VER,
		InSim.Tiny.TINY_PING,
		InSim.Tiny.TINY_VTC,
		InSim.Tiny.TINY_SCP,
		InSim.Tiny.TINY_SST,
		InSim.Tiny.TINY_GTH,
		InSim.Tiny.TINY_ISM,
		InSim.Tiny.TINY_NCN,
		InSim.Tiny.TINY_NPL,
		InSim.Tiny.TINY_RES,
		InSim.Tiny.TINY_NLP,
		InSim.Tiny.TINY_MCI,
		InSim.Tiny.TINY_REO,
		InSim.Tiny.TINY_RST,
		InSim.Tiny.TINY_AXI,
		InSim.Tiny.TINY_RIP,
		InSim.Tiny.TINY_NCI,
		InSim.Tiny.TINY_ALC,
		InSim.Tiny.TINY_AXM,
		InSim.Tiny.TINY_SLC,
		InSim.Tiny.TINY_MAL,
		InSim.Tiny.TINY_PLH,
	]
	if subtype in sendable_tiny_packets:
		insim.send_packet(InSimTinyPacket.new(1, subtype))
	elif subtype == InSim.Tiny.TINY_CLOSE:
		insim.close()


func _on_button_pressed(packet_type: InSim.Packet, subtype := -1) -> void:
	match packet_type:
		InSim.Packet.ISP_ISI:
			initialize_insim()
		InSim.Packet.ISP_TINY:
			test_TINY_packet(subtype)
		InSim.Packet.ISP_SMALL:
			test_SMALL_packet(subtype)
		InSim.Packet.ISP_SCH:
			test_SCH_packet()
		InSim.Packet.ISP_SFP:
			test_SFP_packet()
		InSim.Packet.ISP_SCC:
			test_SCC_packet()
		InSim.Packet.ISP_CPP:
			test_CPP_packet()
		InSim.Packet.ISP_MST:
			test_MST_packet()
		InSim.Packet.ISP_MTC:
			test_MTC_packet()
		#InSim.Packet.ISP_MOD:
			#test_MOD_packet()
		#InSim.Packet.ISP_REO:
			#test_REO_packet()
		InSim.Packet.ISP_MSX:
			test_MSX_packet()
		InSim.Packet.ISP_MSL:
			test_MSL_packet()
		InSim.Packet.ISP_BFN:
			test_BFN_packet()
		InSim.Packet.ISP_BTN:
			test_BTN_packet()
		InSim.Packet.ISP_RIP:
			test_RIP_packet()
		InSim.Packet.ISP_SSH:
			test_SSH_packet()
		InSim.Packet.ISP_PLC:
			test_PLC_packet()
		#InSim.Packet.ISP_AXM:
			#test_AXM_packet()
		InSim.Packet.ISP_HCP:
			test_HCP_packet()
		InSim.Packet.ISP_JRR:
			test_JRR_packet()
		InSim.Packet.ISP_OCO:
			test_OCO_packet()
		#InSim.Packet.ISP_TTC:
			#test_TTC_packet()
		InSim.Packet.ISP_MAL:
			test_MAL_packet()
		InSim.Packet.ISP_PLH:
			test_PLH_packet()


func _on_packet_received(packet: InSimPacket) -> void:
	mark_tested_packet_button(packet)
	if packet is InSimMCIPacket or packet is InSimNLPPacket:
		return
	print_packet(packet)


func _on_packet_sent(packet: InSimPacket) -> void:
	mark_tested_packet_button(packet)

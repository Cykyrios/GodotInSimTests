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


func _on_packet_received(packet: InSimPacket) -> void:
	mark_tested_packet_button(packet)
	if packet is InSimMCIPacket or packet is InSimNLPPacket:
		return
	print_packet(packet)


func _on_packet_sent(packet: InSimPacket) -> void:
	mark_tested_packet_button(packet)

#include <bc_core>

#define PLUGIN "BirdCage: INFO"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new CfgFile[] = "bc/config.cfg";
new file[41]
new textmsg
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_forward( FM_GetGameDescription, "GameDesc" ); 
	
	textmsg = get_user_msgid("SayText")
}
public GameDesc( ) { 
	forward_return( FMV_STRING, "^"Long chim^" is real" ); 
	return FMRES_SUPERCEDE; 
}
public plugin_cfg() {
	get_configsdir(file, 40);
	format(file, 40, "%s/%s",file, CfgFile);
	server_cmd("exec ^"%s^"", file)
}
public plugin_natives() {
	register_native("desc", "desc", 1)
	register_native("info", "info", 1)
}
public desc(id) {
	if(!is_alive(id)) return
	client_mau(id, "Mode Lồng chim là một thể loại sinh tồn, một mình cân cả thế giới")
	client_mau(id, "Ngoài việc chống lại cả thế giới thì ngoài ra còn phải")
	client_mau(id, "tránh bị lồng chim của Doflamingo tạo ra")
	new menu = menu_create("[Lồng chim] Đọc xong ?", "desc_1")
	menu_additem(menu, "Rồi")
	menu_setprop(menu, MPROP_PERPAGE, 0 );
	menu_display(id, menu);
}
public desc_1(id) {
	if(!is_alive(id)) return
	client_mau(id, "Mode này dựa trên một arc của One Piece nên")
	client_mau(id, "trong mode sẽ xuất hiện những thứ có trong One Piece")
	client_mau(id, "như Trái ác quỷ, Haki")
	new menu = menu_create("[Lồng chim] Đọc xong ?", "desc_2")
	menu_additem(menu, "Rồi")
	menu_setprop(menu, MPROP_PERPAGE, 0 );
	menu_display(id, menu);
}
public desc_2(id) {
	if(!is_alive(id)) return
	client_mau(id, "Đấy là tất cả những gì VINA muốn mọi người biết về mode này")
	client_mau(id, "Mọi ý kiến đóng góp xin gửi về fb.com/vinaghost")
}
public info(id) {
	if(!is_alive(id)) return
	
	new menu = menu_create("[Lồng chim] Thông tin", "info_menu")
	menu_additem(menu, "Thông tin ban đầu")
	menu_additem(menu, "Hồi máu")
	menu_additem(menu, "Quà")
	menu_additem(menu, "Trái ác quỷ")
	menu_additem(menu, "Haki")
	menu_display(id, menu);
}
public info_menu( id, menu, item ) {
	if ( item == MENU_EXIT) {
		menu_destroy(menu)
		return
	}
	switch( item )
	{
		case 0:
		{
			info_first(id)
		}
		case 1:
		{
			hoimau(id)
		}
		case 2:
		{
			qua(id)
		}
		case 3:
		{
			acquy(id)
		}
		case 4:
		{
			haki(id)
		}
	}
	
	info(id)
	
}
public info_first(id) {
	client_mau(id, "Gặp NPC Điểm danh để báo danh bắt đầu game")
	client_mau(id, "Vào game sẽ được cấp cho chân và tay còn làm gì được thì cứ làm")
	client_mau(id, "Mục tiêu: Sống sót khổi Lồng chim. kể cả chà đạp lên người khác ._.")
}
public qua(id) {
	client_mau(id, "NPC Quà sẽ cung cấp các loại trái ác quỷ và haki khác nhau")
	client_mau(id, "Nhằm tăng khả năng sống sót khỏi Lồng chim")
}
public hoimau(id) {
	client_mau(id, "Xung quanh map sẽ xuất hiện các điểm hồi máu")
	client_mau(id, "Ngoài ra, NPC Quà còn có cơ hội tăng lượng máu được hồi")
}
public acquy(id) {
	client_mau(id, "Các loại trái ác quỷ sẽ cung cấp các năng lực khác nhau")
	client_mau(id, "CHỨC NĂNG ĐANG TRONG QUÁ TRÌNH XÂY DỰNG")
}
public haki(id) {
	client_mau(id, "Có 3 loại haki: Vũ trang, Quan sát, Bá vương")
	client_mau(id, "CHỨC NĂNG ĐANG TRONG QUÁ TRÌNH XÂY DỰNG")
}
stock client_mau(const id, const input[], any:...) { 
	new count = 1, players[32] 
	
	static msg[191] 
	
	vformat(msg, 190, input, 3) 
	format(msg, 190,"!g[Lồng chim] !y%s",msg)
	
	replace_all(msg, 190, "!g", "^4") 
	replace_all(msg, 190, "!y", "^1") 
	replace_all(msg, 190, "!t", "^3") 
	replace_all(msg, 190, "!t2", "^0") 
	
	if (id) players[0] = id; else get_players(players, count, "ch") 
	
	for (new i = 0; i < count; i++) 
	{ 
		if (is_connected(players[i])) 
		{ 
			message_begin(MSG_ONE_UNRELIABLE, textmsg, _, players[i]) 
			write_byte(players[i]) 
			write_string(msg) 
			message_end() 
		} 
	}  
}

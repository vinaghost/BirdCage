#include <bc_core>

#define PLUGIN "BirdCage: THE LAST"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new textmsg
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	textmsg = get_user_msgid("SayText")
}

public bc_last(id) {
	traogiai(id)
}
public traogiai(id) {
	new name[33]
	get_user_name(id, name, 32)
	
	client_mau(0, "%s đã sống sót khỏi LỒNG CHIM", name)
	
	set_task(5.0, "clear")
	
}
public clear() {
	
	set_progress(WAITING)	
	
	server_cmd("sv_restart 1");
}


stock client_mau(const id, const input[], any:...) 
{ 
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

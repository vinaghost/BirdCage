#include <bc_core>

#define PLUGIN "BirdCage: HACK"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

#define CODER 	ADMIN_LEVEL_C
#define MOD	ADMIN_CVAR

new jumpnum[33], dojump, multijump //multijump
new menu_id, textmsg
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd( "say /quanli","manager", MOD );
	textmsg = get_user_msgid("SayText")
}
public manager( id, lvl, cid )
{
	if ( cmd_access( id, lvl, cid, 0 ) )
	{
		new title[33]
		formatex(title, 32, "\r%s \yQuan li server", "Long chim")
		new menu = menu_create(title, "manager_menu")
		
		menu_additem( menu, "\wADMIN & SMOD & MOD")
		menu_additem( menu, "\wCODER", "- VINA only ._.", CODER)
		
		menu_setprop( menu, MPROP_NUMBER_COLOR, "\r" );
		menu_setprop( menu, MPROP_EXITNAME, "Thoat" );
		menu_display( id, menu );
	}
}
public manager_menu( id, menu, item )
{
	
	switch (item) 
	{
		case 0:
		{
			client_mau(id, "Hi` hi` dang phat trien")
		}
		case 1:
		{
			code(id)
		}
		case MENU_EXIT:
		{
			menu_destroy( menu );
			return PLUGIN_HANDLED;
		}
	}
	
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}
public code(id)
{
	new title[33]
	formatex(title, 32, "\r%s \yVINA Menu ._.", "Long chim")
	menu_id = menu_create(title, "code_menu")
	
	menu_additem( menu_id, "Revive" )
	menu_additem( menu_id, "Noclip")
	menu_additem( menu_id, "Multijump")
	menu_additem( menu_id, "Godmode")
	menu_additem( menu_id, "Reset")
	
	menu_setprop( menu_id, MPROP_NUMBER_COLOR, "\r" );
	menu_setprop( menu_id, MPROP_EXITNAME, "Thoat" );
	menu_display( id, menu_id );
}
public code_menu( id, menu, item )
{
	
	switch (item) 
	{
		case 0:	ExecuteHamB(Ham_CS_RoundRespawn, id )
		case 1:	set_user_noclip(id, !get_user_noclip(id))
		case 2:
		{
			if(Get_BitVar(multijump, id))
				Set_BitVar(multijump, id)
			else
				UnSet_BitVar(multijump, id)
		}
		case 3:	set_user_godmode(id, !get_user_godmode(id))
		case 4: set_progress(WAITING)
		case MENU_EXIT:
		{
			menu_destroy( menu );
			return PLUGIN_HANDLED;
		}
	}
	
	menu_display( id, menu );
	return PLUGIN_HANDLED;
}
public client_PreThink(id) 
{
	if(!is_alive(id)) 
		return PLUGIN_CONTINUE
	if(Get_BitVar(multijump, id))
	{
		if((get_user_button(id) & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(get_user_oldbutton(id) & IN_JUMP)) 
		{
			if(jumpnum[id] < 50) 
			{
				Set_BitVar(dojump, id)
				jumpnum[id]++
				return PLUGIN_CONTINUE
			}
		}
		if((get_user_button(id) & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND)) 
		{
			jumpnum[id] = 0
			return PLUGIN_CONTINUE
		}
	}
	return PLUGIN_CONTINUE
}
public client_PostThink(id) 
{
	if(!is_alive(id))
		return PLUGIN_CONTINUE
	if(Get_BitVar(dojump, id)) 
	{
		new Float:velocity[3]	
		entity_get_vector(id,EV_VEC_velocity,velocity)
		velocity[2] = random_float(265.0,285.0)
		entity_set_vector(id,EV_VEC_velocity,velocity)
		UnSet_BitVar(dojump, id)

		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
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

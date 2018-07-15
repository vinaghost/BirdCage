#include <bc_core>
#include <bc_qua>
//#include <bc_item>

//native menu_class(id)
native diemdanh(id)
	native desc(id)
	native info(id)
	

#define PLUGIN "BirdCage: NPC" //non-player character
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"
enum _:npc {
	DESC,
	INFO,
	DIEMDANH,
	CHEST
}
//Classname for our NPC 
new const g_NpcName[npc][] = {
	"npc_desc",
	"npc_info",
	"npc_diemdanh",
	"npc_chest"
}; 
new const g_NpcName_sprite[npc][] = {
	"sprite_desc",
	"sprite_info",
	"sprite_diemdanh",
	"sprite_chest"
}; 
//Constant model for NPC 
new const g_NpcModel[npc][] = {
	"models/bc/npc/bc_gioithieu.mdl",
	"models/bc/npc/bc_thongtin.mdl",
	"models/bc/npc/bc_diemdanh.mdl",
	"models/bc/npc/bc_qua.mdl"
}
new const g_NpcSprite[npc][] = {
	"sprites/bc/npc/bc_gioithieu.spr",
	"sprites/bc/npc/bc_thongtin.spr",
	"sprites/bc/npc/bc_diemdanh.spr",
	"sprites/bc/npc/bc_qua.spr"
}
new const Float:g_NpcMins[npc][3] = {
	{-16.0, -16.0, -36.0},
	{-31.0, -40.8, -482.8},
	{-16.0, -15.0, -36.0},
	{-12.0, -12.0, 0.0}
	
}
new const Float:g_NpcMaxs[npc][3] = {
	{16.0, 16.0, 36.0},
	{40.13, 40.0, 170.60},
	{16.0, 16.0, 36.0},
	{12.0, 12.0, 75.0}
	
}
new Float: g_Cooldown[32];
new textmsg
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	
	//RegisterHam(Ham_Think, "info_target", "npc_Think");
	
	//RegisterHam(Ham_ObjectCaps, "player", "ObjectCaps", 1 );
	
	register_clcmd("say /npc", "npc_main");
	//register_clcmd("say /delete", "xoathucong");
	textmsg = get_user_msgid("SayText")
	
}
public plugin_precache() {
	for ( new i=0; i < sizeof(g_NpcModel); i++)
	{
		precache_model(g_NpcModel[i])
		precache_model(g_NpcSprite[i])
	}
}
public plugin_cfg() {
	Load_Npc()
}
public xoathucong() {
	for (new i = 0; i < sizeof(g_NpcName);i++)
		remove_entity_name(g_NpcName[i]);
}
public bc_progress(progress) {
	switch (progress)
	{
		case WAITING: 
		{
			Load_Npc()
			remove_entity_name(g_NpcName[3]);
			remove_entity_name(g_NpcName_sprite[3]);
		}
		case COUNTDOWN:
		{
			for (new i = 0; i < 3;i++)
			{
				remove_entity_name(g_NpcName[i]);
				remove_entity_name(g_NpcName_sprite[i]);
			}
			Load_Npc(true)
		}
		
	}
}
/*
public npc_Think(iEnt)
{
	if(!is_valid_ent(iEnt))
		return;
	
	static className[32];
	entity_get_string(iEnt, EV_SZ_classname, className, charsmax(className))
	
	if(equali(className, g_NpcName[0]) || equali(className, g_NpcName[1]))
	{
		
		//Util_PlayAnimation(iEnt, NPC_IdleAnimations[random(sizeof NPC_IdleAnimations)]);
		
		entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + random_float(5.0, 10.0));
	}
}*/
public bc_use_pre(id) {
	/*if(!is_alive(id))
		return PLUGIN_CONTINUE;
	
	if(get_user_button(id) & IN_USE)
	{*/
		static Float: gametime ; gametime = get_gametime();
		if(gametime - 1.0 > g_Cooldown[id])
		{
			static iTarget, iBody, szAimingEnt[32];
			get_user_aiming(id, iTarget, iBody, 75);
			entity_get_string(iTarget, EV_SZ_classname, szAimingEnt, charsmax(szAimingEnt));
			
			if(equali(szAimingEnt, g_NpcName[0]))
			{
				info(id)
			}
			else if(equali(szAimingEnt, g_NpcName[1]))
			{
				desc(id)
			}
			else if(equali(szAimingEnt, g_NpcName[3]))
			{
				bc_qua_random(id)
			}
			else if (equali(szAimingEnt, g_NpcName[2]))
				diemdanh(id)
			
			//Set players cooldown to the current gametime
			g_Cooldown[id] = gametime;
			return PLUGIN_HANDLED
		}
	//}
	
	
	return PLUGIN_CONTINUE
}

public npc_main(id) {
	//Create a new menu
	new menu = menu_create("NPC: Main Menu", "npc_s");
	
	//Add some items to the newly created menu
	menu_additem(menu, "NPC DESC");
	menu_additem(menu, "NPC CLASS");
	menu_additem(menu, "NPC CHEST");
	menu_additem(menu, "NPC DIEM DANH");
	menu_additem(menu, "SAVE NPC")
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public npc_s(id, menu, item) {
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
			npc_desc(id) 
		case 1:
			npc_info(id)
		case 2:
			npc_diemdanh(id)
		case 3:
			npc_chest(id)
		case 4: 
		{
			Save_Npc()
			menu_display(id, menu);
		}
	}
	return PLUGIN_HANDLED;
}
public npc_desc(id) {
	new menu = menu_create("NPC: Describe", "npc_0");
	
	menu_additem(menu, "Create NPC");
	menu_additem(menu, "Delete NPC");
	menu_additem(menu, "Delete all NPC");
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public npc_0(id, menu, item) {
	if(item == MENU_EXIT)
	{
		npc_main(id)
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
			Create_Npc(id, 0);
		case 1:
		{
			//Remove our NPC by the users aim
			new iEnt, body, szClassname[32];
			get_user_aiming(id, iEnt, body);
			
			if (is_valid_ent(iEnt)) 
			{
				entity_get_string(iEnt, EV_SZ_classname, szClassname, charsmax(szClassname));
				
				if (equal(szClassname, g_NpcName[0])) 
				{
					remove_entity(iEnt);
				}
				
			}
		}
		case 2:
		{
			remove_entity_name(g_NpcName[0]);
			
			client_mau(id, "Xoa toan bo NPC DESC")
		}
	}
	
	menu_display(id, menu);
	
	return PLUGIN_HANDLED;
}
public npc_info(id) {
	new menu = menu_create("NPC: INFO", "npc_1");
	
	menu_additem(menu, "Create NPC");
	menu_additem(menu, "Delete NPC");
	menu_additem(menu, "Delete all NPC");
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public npc_1(id, menu, item) {
	if(item == MENU_EXIT)
	{
		npc_main(id)
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
			Create_Npc(id, 1);
		case 1:
		{
			//Remove our NPC by the users aim
			new iEnt, body, szClassname[32];
			get_user_aiming(id, iEnt, body);
			
			if (is_valid_ent(iEnt)) 
			{
				entity_get_string(iEnt, EV_SZ_classname, szClassname, charsmax(szClassname));
				
				if (equal(szClassname, g_NpcName[1])) 
				{
					remove_entity(iEnt);
				}
				
			}
		}
		case 2:
		{
			remove_entity_name(g_NpcName[1]);
			
			client_mau(id, "Xoa toan bo NPC INFO")
		}
	}
	menu_display(id, menu);
	
	return PLUGIN_HANDLED;
}
public npc_diemdanh(id) {
	new menu = menu_create("NPC: Diem danh", "npc_2");
	
	menu_additem(menu, "Create NPC");
	menu_additem(menu, "Delete NPC");
	menu_additem(menu, "Delete all NPC");
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public npc_2(id, menu, item) {
	if(item == MENU_EXIT)
	{
		npc_main(id)
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
			Create_Npc(id, 2);
		case 1:
		{
			//Remove our NPC by the users aim
			new iEnt, body, szClassname[32];
			get_user_aiming(id, iEnt, body);
			
			if (is_valid_ent(iEnt)) 
			{
				entity_get_string(iEnt, EV_SZ_classname, szClassname, charsmax(szClassname));
				
				if (equal(szClassname, g_NpcName[2])) 
				{
					remove_entity(iEnt);
				}
				
			}
		}
		case 2:
		{
			remove_entity_name(g_NpcName[2]);
			
			client_mau(id, "Xoa toan bo NPC DIEM DANH")
		}
	}
	menu_display(id, menu);
	
	return PLUGIN_HANDLED;
}
public npc_chest(id) {
	new menu = menu_create("NPC: Chest", "npc_3");
	
	menu_additem(menu, "Create NPC");
	menu_additem(menu, "Delete NPC");
	menu_additem(menu, "Delete all NPC");
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public npc_3(id, menu, item) {
	if(item == MENU_EXIT)
	{
		npc_main(id)
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
			Create_Npc(id, 3);
		case 1:
		{
			//Remove our NPC by the users aim
			new iEnt, body, szClassname[32];
			get_user_aiming(id, iEnt, body);
			
			if (is_valid_ent(iEnt)) 
			{
				entity_get_string(iEnt, EV_SZ_classname, szClassname, charsmax(szClassname));
				
				if (equal(szClassname, g_NpcName[3])) 
				{
					remove_entity(iEnt);
				}
				
			}
		}
		case 2:
		{
			remove_entity_name(g_NpcName[3]);
			
			client_mau(id, "Xoa toan bo NPC CHEST")
		}
	}
	menu_display(id, menu);
	
	return PLUGIN_HANDLED;
}
Create_Npc(id, type, Float:flOrigin[3]= { 0.0, 0.0, 0.0 }, Float:flAngle[3]= { 0.0, 0.0, 0.0 } ) {
	new iEnt = create_entity("info_target");
	
	entity_set_string(iEnt, EV_SZ_classname, g_NpcName[type]);
	
	if(id)
	{
		entity_get_vector(id, EV_VEC_origin, flOrigin);
		entity_set_origin(iEnt, flOrigin);
		create_title(type, flOrigin)
		flOrigin[2] += 80.0;
		entity_set_origin(id, flOrigin);
		
		entity_get_vector(id, EV_VEC_angles, flAngle);
		flAngle[0] = 0.0;
	}
	else 
	{
		entity_set_origin(iEnt, flOrigin);
		create_title(type, flOrigin)
	}
	
	if( type == 2) 
	{
		//	creat_chest(iEnt)
		flAngle[1] -= 90
		
	}
	
	entity_set_vector(iEnt, EV_VEC_angles, flAngle);
	
	entity_set_model(iEnt, g_NpcModel[type]);
	entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_PUSHSTEP);
	entity_set_int(iEnt, EV_INT_solid, SOLID_BBOX);
	
	
	entity_set_size(iEnt, g_NpcMins[type], g_NpcMaxs[type]);
	
	
	entity_set_byte(iEnt,EV_BYTE_controller1,125);
	// entity_set_byte(ent,EV_BYTE_controller2,125);
	// entity_set_byte(ent,EV_BYTE_controller3,125);
	// entity_set_byte(ent,EV_BYTE_controller4,125);
	
	drop_to_floor(iEnt);
	//entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.01)
}
create_title(type, Float:origin[3]) {
	new iEnt = create_entity("info_target");
	
	entity_set_string(iEnt, EV_SZ_classname, g_NpcName_sprite[type]);
	
	origin[0] -= 10.0;//x
	//[1]		//y
	origin[2] += 40.0;//z
	entity_set_origin(iEnt, origin);
	set_rendering(iEnt, kRenderFxNone, 0, 0, 0, kRenderTransAdd, 255) 
	entity_set_model(iEnt, g_NpcSprite[type]);
}

Load_Npc(bool:chest = false) {
	new szConfigDir[256], szFile[256], szNpcDir[256];
	
	get_configsdir(szConfigDir, charsmax(szConfigDir));
	
	new szMapName[32];
	get_mapname(szMapName, charsmax(szMapName));
	
	formatex(szNpcDir, charsmax(szNpcDir),"%s/bc/NPC", szConfigDir);
	formatex(szFile, charsmax(szFile),  "%s/%s.cfg", szNpcDir, szMapName);
	
	if(!dir_exists(szNpcDir))
	{
		mkdir(szNpcDir);
	}
	
	if(!file_exists(szFile))
	{
		write_file(szFile, "");
	}
	
	new szFileOrigin[3][32]
	new sOrigin[128], sAngle[128];
	new Float:fOrigin[3], Float:fAngles[3], type;
	new iLine, iLength, sBuffer[256];
	new sType[15], sTemp[50]
	
	while(read_file(szFile, iLine++, sBuffer, charsmax(sBuffer), iLength))
	{
		if((sBuffer[0]== ';') || !iLength)
			continue;
		strtok(sBuffer, sType, charsmax(sType), sTemp, charsmax(sTemp), '/');
		type = str_to_num(sType)
		if ( !chest && (type == CHEST) ) continue;
		if ( chest && (type != CHEST) ) continue;
		
		strtok(sTemp, sOrigin, charsmax(sOrigin), sAngle, charsmax(sAngle), '|');
		
		parse(sOrigin, szFileOrigin[0], charsmax(szFileOrigin[]), szFileOrigin[1], charsmax(szFileOrigin[]), szFileOrigin[2], charsmax(szFileOrigin[]));
		
		fOrigin[0] = str_to_float(szFileOrigin[0]);
		fOrigin[1] = str_to_float(szFileOrigin[1]);
		fOrigin[2] = str_to_float(szFileOrigin[2]);
		
		fAngles[1] = str_to_float(sAngle[1]);
		
		
		
		Create_Npc(0, type, fOrigin, fAngles)
	}
}

Save_Npc() {
	new szConfigsDir[256], szFile[256], szNpcDir[256];
	
	get_configsdir(szConfigsDir, charsmax(szConfigsDir));
	
	new szMapName[32];
	get_mapname(szMapName, charsmax(szMapName));
	
	formatex(szNpcDir, charsmax(szNpcDir),"%s/bc/NPC", szConfigsDir);
	formatex(szFile, charsmax(szFile), "%s/%s.cfg", szNpcDir, szMapName);
	
	if(file_exists(szFile)) delete_file(szFile);
	
	new iEnt = -1, Float:fEntOrigin[3], Float:fEntAngles[3];
	new sBuffer[256];
	
	for (new i = 0; i < sizeof(g_NpcName); i++)
	{
		while( ( iEnt = find_ent_by_class(iEnt, g_NpcName[i]) ) )
		{
			entity_get_vector(iEnt, EV_VEC_origin, fEntOrigin);
			entity_get_vector(iEnt, EV_VEC_angles, fEntAngles);
			if( i == 2) fEntAngles[1] += 90
			formatex(sBuffer, charsmax(sBuffer), "%d / %d %d %d | %d", i,  floatround(fEntOrigin[0]), floatround(fEntOrigin[1]), floatround(fEntOrigin[2]), floatround(fEntAngles[1]));
			
			write_file(szFile, sBuffer, -1);
		}
	}
	
}
stock Util_PlayAnimation(index, sequence, Float: framerate = 1.0) {
	entity_set_float(index, EV_FL_animtime, get_gametime());
	entity_set_float(index, EV_FL_framerate,  framerate);
	entity_set_float(index, EV_FL_frame, 0.0);
	entity_set_int(index, EV_INT_sequence, sequence);
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

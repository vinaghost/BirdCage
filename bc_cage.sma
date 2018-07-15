#include <bc_core>
#include <screenfade_util>
#include <xs>
#include <dhudmessage>

#define PLUGIN "BirdCage: CAGE"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

#define GIAM DIST/20
#define ID_SMALLER 113
new szFile[256], szDir[256]
new Array:a_origin, num
new Float:current[3], bankinh
const DMG_GRENADE     = (1 << 24)

new g_iGrenade
new const center_name[] = "center"
new Float:g_icon_delay[33]
new g_icon, id_icon
new const icon_spr[] = "sprites/bc/center.spr"
new const center_mdl[] = "models/bc/table.mdl"

new DIST
//new msg_hostagepos, msg_hostagek
//new maxplayer
/*new const color[][3] = {
	{ 0, 0, 0 },
	{ 255, 0, 0 },
	{ 0, 0, 255 }
}*/	
/*enum _: mau{
	NO,
	WARN,
	SML
}
new faded*/


new f_origin[3], s_origin[3]
new textmsg

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /dist", "khoangcach")
	
	register_think(center_name,"center_think");
	//RegisterHam(Ham_Think, "info_target", "center_think"); 
	
	//set_task(2.0, "update_radar", _, _, _, "b")
	
	///msg_hostagek = get_user_msgid("HostageK")
	//msg_hostagepos = get_user_msgid("HostagePos")
	
	//maxplayer = get_maxplayers()
	
	textmsg = get_user_msgid("SayText")
}
public plugin_precache() {
	g_icon = precache_model(icon_spr)
	precache_model(center_mdl)
}

public plugin_cfg() {
	
	get_configsdir(szFile, charsmax(szFile));
	new szMapName[32];
	get_mapname(szMapName, charsmax(szMapName));
	formatex(szDir, charsmax(szDir),"%s/bc/centerbattle",szFile)
	formatex(szFile, charsmax(szFile), "%s/%s.cfg", szDir, szMapName);
	
	a_origin = ArrayCreate(3)
	
	center_load()
	
	g_iGrenade = create_entity("grenade")
}
public center_load() {
	
	if(!dir_exists(szDir))
		mkdir(szDir);
	if(!file_exists(szFile))
		write_file(szFile, "");
	new sOrigin[128]
	new Float: Origin[3]
	new szFileOrigin[3][32]
	new iLine, iLength
	
	while(read_file(szFile, iLine++, sOrigin, charsmax(sOrigin), iLength))
	{
		if( iLine == 1) {
			DIST = str_to_num(sOrigin)
			if( DIST < 10) DIST = 200
			continue;
		}		
		if((sOrigin[0]== ';') || !iLength)
			continue;
		
		parse(sOrigin, szFileOrigin[0], charsmax(szFileOrigin[]), szFileOrigin[1], charsmax(szFileOrigin[]), szFileOrigin[2], charsmax(szFileOrigin[]));
		
		Origin[0] = str_to_float(szFileOrigin[0]);
		Origin[1] = str_to_float(szFileOrigin[1]);
		Origin[2] = str_to_float(szFileOrigin[2]);
		
		ArrayPushArray(a_origin, Origin)
		
		num++
	}
}

public center_save() {
	if(file_exists(szFile)) delete_file(szFile);
	
	new Float:origin[3], sBuffer[150]
	formatex(sBuffer, charsmax(sBuffer), "%d", DIST)
	write_file(szFile, sBuffer, -1);
	
	for (new i = 0 ; i < num ; i++) {
		
		ArrayGetArray(a_origin, i , origin)
		formatex(sBuffer, charsmax(sBuffer), "%d %d %d", origin[0] , origin[1], origin[2])
		
		write_file(szFile, sBuffer, -1);
	}
}
public bc_progress(progress) {
	switch (progress)
	{
		case START: {
		
			client_mau(0, "LỒNG CHIM ĐANG BẮT ĐẦU CO LẠI")
			random_center()
			bankinh = DIST
			set_task(10.0, "smaller")
			}
		case WAITING:
		{
			remove_ent_by_class("center")
			if(task_exists(ID_SMALLER))
				remove_task(ID_SMALLER)
		}
	}
	
	
}
public random_center() {
	new n = random_num(0, num -1)
	ArrayGetArray(a_origin, n , current)
	
	new ent = create_entity("info_target")
	
	entity_set_string(ent,EV_SZ_classname, center_name)
	entity_set_model(ent,center_mdl)
	entity_set_origin(ent, current);
	entity_set_int(ent,EV_INT_solid,SOLID_BBOX)
	
	
	new Float:mins[3] = {-20.6,-28.94,-47.0}
	new Float:maxs[3] = {20.59,10.27,46.95}
	entity_set_size(ent,mins,maxs)
	drop_to_floor(ent);
	
	entity_set_float(ent, EV_FL_nextthink, get_gametime() + 1.0) 
	
	id_icon = ent
}
public smaller() {
	if(bankinh - GIAM < 0) return;
	bankinh -= GIAM
	set_task(20.0, "smaller", ID_SMALLER)
	
	set_dhudmessage(255, 0, 0, -1.0, 0.3, 2, 1.0, 1.0, 0.1)	
	show_dhudmessage(0, "ĐI THEO BÓNG MẶT TRỜI")
}
public sml(id) {
	//fade(id, SML)
	UTIL_ScreenFade(id,{0,0,0}, _, 2.0,245)
	Grenade_Attack(id, 10.0)
	
	//ExtraDamage(id, "bum cheo") 
}
public warning(id) {
	if( is_alive(id) )
	{
		//fade(id, WARN)
		UTIL_ScreenFade(id,{255,0,0},_ ,2.0 ,175)
		//set_dhudmessage(0, 0, 255, 0.31, 2.31, 2, 1.0, 1.0, 0.1)
		
		//show_dhudmessage(id, "ĐI THEO BÓNG MẶT TRỜI")
	}
}
/*
stock ExtraDamage(id, Float:damage, weaponDescription[]) { 
	if(is_alive(id))  
	{ 
		static Float:userHealth 
		pev(id, pev_health, userHealth) 
		
		if(userHealth - damage < 1.0) 
		{ 
			make_deathmsg ( 0, id, 0, weaponDescription ) 
			user_silentkill(id) 
		} 
		else 
		{ 
			set_pev(id, pev_health, userHealth - damage) 
		} 
	} 
}*/
public center_think(iEnt) 
{ 
	if(!is_valid_ent(iEnt)) 
		return; 
	
	new Float:PlayerOrigin[3], Float:distance
	
	new players[32], iNum, id
	get_players(players, iNum, "ae","CT");
	for(new i = 0 ; i < iNum; i++) 
	{ 
		id = players[i]
		pev(id, pev_origin, PlayerOrigin) 
		distance = get_distance_f( current, PlayerOrigin )
		if( distance  > bankinh) 
		{
			sml(id)
			//client_mau(0, "%d", id)
		}
		else if ( distance > bankinh - GIAM)
		{
			warning(id)
			//client_mau(0, "%d", id)
		}
		else 
		{
			/*if (Get_BitVar(faded,id)) 
			{
				UnSet_BitVar(faded,id)
				//fade(id, NO)
			}*/
		}
		//client_mau(0, "%d %f",id, distance)
		
	}  
	//client_mau(0, "%d", iNum)
	//client_mau(0, "Chao tui dang suy nghi day ._.")
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 1.0); 
} 
	
stock Grenade_Attack(id, Float:flDamage)
{
	ExecuteHamB(Ham_TakeDamage, id, g_iGrenade, g_iGrenade, flDamage, DMG_GRENADE)
}
public khoangcach(id) {
	if(!is_alive(id)) return
	
	new menu = menu_create("TAO TAM", "khoangcach_menu")
	menu_additem(menu, "TAO TAM")
	menu_additem(menu, "KHOANG CACH TOI TAM")
	menu_additem(menu, "SAVE")
	menu_additem(menu, "DO KHOANG CACH")
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public khoangcach_menu(id, menu, item) {
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
		{
			new origin[3] 
			get_user_origin(id, origin)
			ArrayPushArray(a_origin, origin)
			num ++ 
			client_mau(id, "%d %d %d - da duoc them", origin[0], origin[1], origin[2])
			menu_display(id, menu);
			
		}
		case 1:
		{
			client_mau(id, "Khoang cach toi tam la: %d", get_entity_distance(id_icon, id))
			menu_display(id, menu);
		}
		case 2:
		{
			center_save()
			menu_display(id, menu);
		}
		case 3: 
		{
			get_user_origin(id, f_origin)
			do_khoang_cach(id)
		}
	}
	return PLUGIN_HANDLED;
}
public do_khoang_cach(id) {
	if(!is_alive(id)) return
	
	new menu = menu_create("Di toi cho can do de ._.", "do_khoang_cach_menu")
	menu_additem(menu, "TAO TOI ROI NAY")
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	menu_display(id, menu);
}
public do_khoang_cach_menu(id, menu, item) {
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	switch(item)
	{
		case 0:
		{
			get_user_origin(id, s_origin)
			new distance
			distance = get_distance(f_origin, s_origin)
			client_mau(id, "Khoang cach giua 2 diem la: %d", distance)
			khoangcach(id)
		}
	}
	return PLUGIN_HANDLED;
}
public client_PostThink(id)
{
	if (!is_alive(id) || get_progress() != START)
		return
	if(g_icon_delay[id] + 0.1 > get_gametime())
		return
	
	g_icon_delay[id] = get_gametime()
	create_icon_origin(id, id_icon, g_icon)
	
	
}
stock create_icon_origin(id, ent, sprite) // By sontung0
{
	if (!pev_valid(ent)) return;
	
	new Float:fMyOrigin[3]
	entity_get_vector(id, EV_VEC_origin, fMyOrigin)
	
	new target = ent
	new Float:fTargetOrigin[3]
	entity_get_vector(target, EV_VEC_origin, fTargetOrigin)
	fTargetOrigin[2] += 40.0
	
	if (!is_in_viewcone(id, fTargetOrigin)) return;
	
	new Float:fMiddle[3], Float:fHitPoint[3]
	xs_vec_sub(fTargetOrigin, fMyOrigin, fMiddle)
	trace_line(-1, fMyOrigin, fTargetOrigin, fHitPoint)
	
	new Float:fWallOffset[3], Float:fDistanceToWall
	fDistanceToWall = vector_distance(fMyOrigin, fHitPoint) - 10.0
	normalize(fMiddle, fWallOffset, fDistanceToWall)
	
	new Float:fSpriteOffset[3]
	xs_vec_add(fWallOffset, fMyOrigin, fSpriteOffset)
	new Float:fScale
	fScale = 0.01 * fDistanceToWall
	
	new scale = floatround(fScale)
	scale = max(scale, 1)
	scale = min(scale, 2)
	scale = max(scale, 1)
	
	te_sprite(id, fSpriteOffset, sprite, scale, 100)
}

stock te_sprite(id, Float:origin[3], sprite, scale, brightness) // By sontung0
{	
	message_begin(MSG_ONE, SVC_TEMPENTITY, _, id)
	write_byte(TE_SPRITE)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite)
	write_byte(scale) 
	write_byte(brightness)
	message_end()
}

stock normalize(Float:fIn[3], Float:fOut[3], Float:fMul) // By sontung0
{
	new Float:fLen = xs_vec_len(fIn)
	xs_vec_copy(fIn, fOut)
	
	fOut[0] /= fLen, fOut[1] /= fLen, fOut[2] /= fLen
	fOut[0] *= fMul, fOut[1] *= fMul, fOut[2] *= fMul
}
stock remove_ent_by_class(classname[])
{
	new nextitem  = find_ent_by_class(-1, classname)
	while(nextitem)
	{
		remove_entity(nextitem)
		nextitem = find_ent_by_class(-1, classname)
	}
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

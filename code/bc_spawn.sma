#include <bc_core>
#include <fakemeta_util>
#define PLUGIN "BirdCage: SPAWN"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new g_SpawnFile[256]
new bool:g_LoadSuccessed = false
new bool:g_LoadInit = false

#define	MAX_BATTLE	60
new Float:g_SpawnVecs[MAX_BATTLE][3];
new Float:g_SpawnAngles[MAX_BATTLE][3];
new Float:g_SpawnVAngles[MAX_BATTLE][3];
new g_TotalSpawns = 0;

new ready, readyer /* ._. */
//new battle, Float:loc[32][3], locnum
//new bool:g_isSolid[33]
//new bool:g_isSemiClip[33]
//new g_iPlayers[32], g_iNum, g_iPlayer

new list[MAX_BATTLE], id_spawn
new textmsg

new g_name[] = "respawn"
new afk[33]


public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	//register_forward( FM_CmdStart, "CmdStart" )
	
	g_LoadInit = true // disabled pfn_keyvalue using
	//register_clcmd("say /info", "info")
	
	textmsg = get_user_msgid("SayText")
	readyer = 0
	
	/*register_clcmd("menuselect", "ClCmd_MenuSelect_JoinClass"); // old style menu
	register_clcmd("joinclass", "ClCmd_MenuSelect_JoinClass"); // VGUI menu*/
	register_think(g_name,"taodangsuynghi")
	
	//register_clcmd("say /real", "dem")
	register_clcmd("say /respawn", "hoisinh")
	register_clcmd("say /hoisinh", "hoisinh")
	
	new ent = create_entity("info_target") 
	
	if(ent) 
	{ 
		entity_set_string(ent, EV_SZ_classname, g_name) 
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 10.0) 
	}
}

public plugin_natives() {
	register_native("diemdanh", "_check", 1)
}
public _check(id) {
	check(id)
}
public check(id) {
	if( Get_BitVar(ready, id) ) 
	{
		client_mau(id, "Đã sẵn sàng rồi")
		return
	}
	
	Set_BitVar(ready, id)
	readyer++
	new name[33]
	get_user_name(id, name, charsmax(name))
	client_mau(0, "!t%s!y đã sẵn sàng!", name)
	new player = get_realplayersnum()
	
	if ( readyer >= player )
	{
		set_progress(COUNTDOWN)
		//client_mau(0, "So nguoi that: %d" , get_realplayersnum() )
	}
	else 
		client_mau(0, "Cần thêm %d người nữa để LỒNG CHIM xuất hiện", player - readyer)
	
}
public dem() {
	client_mau(0, "So nguoi that: %d" , get_realplayersnum() )
}
public client_disconnect(id) {
	if(get_progress() == WAITING )
	{
		if( Get_BitVar(ready, id) )
		{
			UnSet_BitVar(ready, id) 
			readyer --
			new player = get_realplayersnum()
			
			if ( readyer >= player )
				set_progress(COUNTDOWN)
			else 
				client_mau(0, "Cần thêm %d người nữa để LỒNG CHIM xuất hiện", player - readyer)
		}
	}
	
}
public client_connect(id) {
	
	UnSet_BitVar(ready, id) 
	client_mau(0, "Cần thêm %d người nữa để LỒNG CHIM xuất hiện", get_realplayersnum() - readyer)
	
}
public bc_progress(progress) {
	
	switch (progress)
	{
		case WAITING:
		{
			new players[32], iNum
			get_players(players, iNum, "e","CT")
			for(new i = 0 ; i < iNum; i++) 
			{ 
				UnSet_BitVar(ready, players[i]) 
				afk[players[i]] = 0
			}
			readyer = 0
		}
		case COUNTDOWN:
		{
			battle_time()
		}
		case START :
		{
			battle_destroy()
		}
		}
}
public bc_spawn(id) {
	if( get_progress() != WAITING) user_silentkill(id)
}
public hoisinh(id) {
	if(get_progress() != WAITING) return
	if( !is_alive(id) ) ExecuteHamB(Ham_CS_RoundRespawn, id)
}
public taodangsuynghi(ent) {
	
	if(is_valid_ent(ent))
	{
		if(get_progress() == WAITING)
		{
			
			new players[32], playerCnt;
			get_players(players, playerCnt, "bce","CT");
			
			if ( playerCnt > 0 )  {
				for ( new i = 0 ; i < playerCnt ; i++ )
				{
					afk_couter(players[i])
					client_mau(players[i], "Go /respawn hoac /hoisinh de duoc hoi sinh")
				}
			}
		}
		
		
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 10.0);
	}
	
}
public afk_couter(id) {
	if( get_user_team(id) != 2) return
	afk[id]++
	if( afk[id] > 3 ) server_cmd("kick #%d ^"AFK ._.^"", id)
}
public battle_time() {
	
	new players[32], playerCnt;
	get_players(players, playerCnt, "e","CT");
	
	id_spawn = random_num(1, g_TotalSpawns-1)
	
	for ( new i = 0 ; i < playerCnt ; i++ )
		battle_point(players[i])
	
}
public battle_point(id) {
	
	spawn_Preset(id)
	
	strip_user_weapons(id)
	//fm_strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	set_user_health(id, 100)
	
	client_mau(id, "Teleport thành công ra chiến trường.")
	client_mau(id, "Sẵn sàng !gCHIẾN ĐẤU!y ._.")
}
public battle_destroy() {
	arrayset(list, 0, MAX_BATTLE)
}
public spawn_Preset(id)
{
	
	if( !is_alive(id) )
		ExecuteHamB(Ham_CS_RoundRespawn, id)
	if( id_spawn > g_TotalSpawns ) id_spawn = 0
	while ( g_SpawnVecs[id_spawn][0]  == 0.0 && g_SpawnVecs[id_spawn][1]  == 0.0 && g_SpawnVecs[id_spawn][2]  == 0) 
		id_spawn ++
	
	new Float:mins[3], Float:maxs[3]
	pev(id, pev_mins, mins)
	pev(id, pev_maxs, maxs)
	engfunc(EngFunc_SetSize, id, mins, maxs)
	engfunc(EngFunc_SetOrigin, id, g_SpawnVecs[id_spawn])
	set_pev(id, pev_fixangle, 1)
	set_pev(id, pev_angles, g_SpawnAngles[id_spawn])
	set_pev(id, pev_v_angle, g_SpawnVAngles[id_spawn])
	set_pev(id, pev_fixangle, 1)
	
	id_spawn++
}
//load spawns from file, Return 0 when didn't load anything.
stock Load_SpawnFlie(type) //createEntity = 1 create an entity when load a point
{
	if (file_exists(g_SpawnFile))
	{
		new ent_T, ent_CT
		new Data[128], len, line = 0
		new team[8], p_origin[3][8], p_angles[3][8]
		new Float:origin[3], Float:angles[3]
		
		while((line = read_file(g_SpawnFile , line , Data , 127 , len) ) != 0 ) 
		{
			if (strlen(Data)<2) continue
			
			parse(Data, team,7, p_origin[0],7, p_origin[1],7, p_origin[2],7, p_angles[0],7, p_angles[1],7, p_angles[2],7)
			
			origin[0] = str_to_float(p_origin[0]); origin[1] = str_to_float(p_origin[1]); origin[2] = str_to_float(p_origin[2]);
			angles[0] = str_to_float(p_angles[0]); angles[1] = str_to_float(p_angles[1]); angles[2] = str_to_float(p_angles[2]);
			
			if (equali(team,"T")){
				if (type==1) ent_T = create_entity("info_player_deathmatch")
				else ent_T = find_ent_by_class(ent_T, "info_player_deathmatch")
				if (ent_T>0){
					entity_set_int(ent_T,EV_INT_iuser1,1) // mark that create by map spawns editor
					entity_set_origin(ent_T,origin)
					entity_set_vector(ent_T, EV_VEC_angles, angles)
				}
			}
			else if (equali(team,"CT")){
				if (type==1) ent_CT = create_entity("info_player_start")
				else ent_CT = find_ent_by_class(ent_CT, "info_player_start")
				if (ent_CT>0){
					entity_set_int(ent_CT,EV_INT_iuser1,1) // mark that create by map spawns editor
					entity_set_origin(ent_CT,origin)
					entity_set_vector(ent_CT, EV_VEC_angles, angles)
				}
			}
		}
		return 1
	}
	return 0
}
// pfn_keyvalue..Execure after plugin_precache and before plugin_init
public pfn_keyvalue(entid)
{  // when load custom spawns file successed,we are del all spawns by map originate create
	if (g_LoadSuccessed && !g_LoadInit){
		new classname[32], key[32], value[32]
		copy_keyvalue(classname, 31, key, 31, value, 31)
		
		if (equal(classname, "info_player_deathmatch") || equal(classname, "info_player_start")){
			if (is_valid_ent(entid) && entity_get_int(entid,EV_INT_iuser1)!=1) //filter out custom spawns
				remove_entity(entid)
		}
	}
	return PLUGIN_CONTINUE
}
public plugin_precache() {
	new configdir[128]
	get_configsdir(configdir, 127 )
	new spawndir[256]
	format(spawndir,255,"%s/bc/spawns",configdir)
	if (!dir_exists(spawndir)){
		if (mkdir(spawndir)==0){ // Create a dir,if it's not exist
			log_amx("Create [%s] dir successfully finished.",spawndir)
			}else{
			log_error(AMX_ERR_NOTFOUND,"Couldn't create [%s] dir,plugin stoped.",spawndir)
			pause("ad")
			return PLUGIN_CONTINUE
		}
	}
	
	new MapName[32]
	get_mapname(MapName, 31)
	format(g_SpawnFile, 255, "%s/%s_spawns.cfg",spawndir, MapName)
	
	if (Load_SpawnFlie(1))
		g_LoadSuccessed = true
	else
		g_LoadSuccessed = false
	
	g_TotalSpawns = 0;
	
	format(g_SpawnFile, 255, "%s/%s_battle.cfg",spawndir, MapName)
	if (file_exists(g_SpawnFile)) 
	{
		new Data[124], len
		new line = 0
		new pos[12][8]
		
		while(g_TotalSpawns < MAX_BATTLE && (line = read_file(g_SpawnFile , line , Data , 123 , len) ) != 0 ) 
		{
			if (strlen(Data)<2 || Data[0] == '[')
				continue;
			
			parse(Data, pos[1], 7, pos[2], 7, pos[3], 7, pos[4], 7, pos[5], 7, pos[6], 7, pos[7], 7, pos[8], 7, pos[9], 7, pos[10], 7);
			
			// Origin
			g_SpawnVecs[g_TotalSpawns][0] = str_to_float(pos[1])
			g_SpawnVecs[g_TotalSpawns][1] = str_to_float(pos[2])
			g_SpawnVecs[g_TotalSpawns][2] = str_to_float(pos[3])
			
			//Angles
			g_SpawnAngles[g_TotalSpawns][0] = str_to_float(pos[4])
			g_SpawnAngles[g_TotalSpawns][1] = str_to_float(pos[5])
			g_SpawnAngles[g_TotalSpawns][2] = str_to_float(pos[6])
			
			//v-Angles
			g_SpawnVAngles[g_TotalSpawns][0] = str_to_float(pos[8])
			g_SpawnVAngles[g_TotalSpawns][1] = str_to_float(pos[9])
			g_SpawnVAngles[g_TotalSpawns][2] = str_to_float(pos[10])
			
			//Team - ignore - 7
			
			g_TotalSpawns++;
		}
	}
	return PLUGIN_CONTINUE
}
stock get_realplayersnum()
{
	new players[32], playerCnt;
	get_players(players, playerCnt, "ce","CT");
	
	return playerCnt;
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
}/*
public ClCmd_MenuSelect_JoinClass(id)
{
	if( get_progress() == WAITING) return PLUGIN_HANDLED;
	if( get_pdata_int(id, m_iMenu) == MENU_CHOOSEAPPEARANCE && get_pdata_int(id, m_iJoiningState) == JOIN_CHOOSEAPPEARANCE )
	{
		new command[11], arg1[32];
		read_argv(0, command, charsmax(command));
		read_argv(1, arg1, charsmax(arg1));
		engclient_cmd(id, command, arg1);
		ExecuteHam(Ham_Player_PreThink, id);
		if( !is_user_alive(id) )
		{
			if(get_user_team(id) == 2) {
				ExecuteHamB(Ham_CS_RoundRespawn, id )
				client_mau(0, "Cần thêm %d người nữa để LỒNG CHIM xuất hiện", get_realplayersnum() - readyer)
			}
		}
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}
*/

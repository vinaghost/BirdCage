#include <bc_core>
#include <dhudmessage>
#include <screenfade_util>


#define PLUGIN "BirdCage: COUNTDOWN"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new countdown
new time_s
new speak[ 10 ][] = { 
	"bc/one.wav", 
	"bc/two.wav",
	"bc/three.wav",
	"bc/four.wav",
	"bc/five.wav",
	"bc/six.wav",
	"bc/seven.wav",
	"bc/eight.wav",
	"bc/nine.wav",
	"bc/ten.wav"
}
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
}
public plugin_precache() {
	for (new i ; i < 10; i++)
		precache_sound(speak[i])
}
public bc_progress(progress) {
	if ( progress == COUNTDOWN )
	{
		//client_print(0, print_chat, "alo alo alo")
		time_s = 10
		countdown = 9
		bc_countdown()
		UTIL_FadeToWhite(0, 10.0)
		
		new iPlayers[ 32 ] , iNum , i 
		get_players( iPlayers , iNum , "a" );
		
		for( i = 0; i < iNum; i++ )
		{
			Freeze(iPlayers[ i ] )			
		} 
	}
}
stock Freeze(id)
{ 
	new iFlags = pev( id , pev_flags );
	
	if( ~iFlags & FL_FROZEN ) 
		set_pev( id , pev_flags , iFlags | FL_FROZEN );
	
	
}
public UnFreeze(id)
{ 
	new iFlags = pev( id , pev_flags ) ;
	
	if( iFlags & FL_FROZEN ) 
		set_pev( id , pev_flags , iFlags & ~FL_FROZEN ) ;
}
public bc_countdown() {    
	emit_sound( 0, CHAN_VOICE, speak[ countdown ], 1.0, ATTN_NORM, 0, PITCH_NORM )
	countdown--
	
	set_dhudmessage(179, 0, 0, -1.0, 0.28, 2, 0.02, 1.0, 0.01, 0.1)
	show_dhudmessage(0, "%d", time_s); 
	--time_s;
	
	if(time_s > 0)
	{
		set_task(1.0, "bc_countdown")
	}
	else 
	{
		new iPlayers[ 32 ] , iNum , i 
		get_players( iPlayers , iNum , "a" );
		for( i = 0; i < iNum; i++ )
		{
			UnFreeze(iPlayers[ i ] )			
		}
		set_progress(START)
	}
}

#include <bc_core>
#include <bc_qua>
#include <bc_traiacquy>

#define PLUGIN "BirdCage: Goro Goro no mi"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new acquy
new iLightning,gmsgScreenFade

new gSound[]="bc/taq/lightningbolt.wav";
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	gmsgScreenFade=get_user_msgid("ScreenFade");
	
	acquy = bc_acquy_register("Goro Goro", 20, 0, LOGIA)
}
public plugin_precache(){
	
	iLightning=precache_model("sprites/lgtning.spr");
	precache_sound(gSound);
}

public bc_taq_kichhoat(id, id_trai) {
	if (id_trai == acquy)
	{
		new target , iBodyPart;
		get_user_aiming( id , target , iBodyPart );
		
		if ( is_alive( target ) )
		{
			CreateLightning( target )
			
			ExecuteHamB(Ham_TakeDamage, target,  id,  id, 90.0, DMG_SHOCK)
		}
	}
}

CreateLightning( id ){
	new Float:fOrigin[3];
	new iLineWidth=120;
	new iOrigin[3], iOrigin2[3];
	pev(id, pev_origin, fOrigin);
	
	iOrigin[0]=floatround(fOrigin[0]);
	iOrigin[1]=floatround(fOrigin[1]);
	iOrigin[2]=floatround(fOrigin[2])-50;
	iOrigin2[0]=iOrigin[0];
	iOrigin2[1]=iOrigin[1];
	iOrigin2[2]=iOrigin[2]+500;
	Create_TE_BEAMPOINTS(iOrigin, iOrigin2,iLightning, 0, 15, 10, iLineWidth, 10, 255, 255, 255, 255, 0);
	emit_sound( id, CHAN_STATIC, gSound, 1.0, ATTN_NORM, 0, PITCH_NORM );
	Create_ScreenFade(id, (1<<12), (1<<6), 0, 255, 255, 255, 255);
}
Create_ScreenFade(id, duration, holdtime, fadetype, red, green, blue, alpha){

	message_begin( MSG_ONE,gmsgScreenFade,{0,0,0},id );			
	write_short( duration );		// fade lasts this long duration
	write_short( holdtime );			// fade lasts this long hold time
	write_short( fadetype );			// fade type (in / out)
	write_byte( red );				// fade red
	write_byte( green );				// fade green
	write_byte( blue );				// fade blue
	write_byte( alpha );				// fade alpha
	message_end();
}
Create_TE_BEAMPOINTS(start[3], end[3], iSprite, startFrame, frameRate, life, width, noise, red, green, blue, alpha, speed){

	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte( TE_BEAMPOINTS );
	write_coord( start[0] );
	write_coord( start[1] );
	write_coord( start[2] );
	write_coord( end[0] );
	write_coord( end[1] );
	write_coord( end[2] );
	write_short( iSprite );			// model
	write_byte( startFrame );		// start frame
	write_byte( frameRate );		// framerate
	write_byte( life );				// life
	write_byte( width );				// width
	write_byte( noise );				// noise
	write_byte( red);				// red
	write_byte( green );				// green
	write_byte( blue );				// blue
	write_byte( alpha );				// brightness
	write_byte( speed );				// speed
	message_end();
}

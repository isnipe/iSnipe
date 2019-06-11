#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

EnableAntiHardScope(time)
{
    self endon( "disconnect" );
    self endon( "death" );

    if( !isDefined( time ) || time < 0.05 )
        time = 3;

    adsTime = 0;

    for( ;; )
    {
        if( self playerAds() == 1 )
            adsTime ++;
        else
            adsTime = 0;

        if( adsTime >= int( time / 0.05 ) )
        {
            adsTime = 0;
            self allowAds( false );

            while( self playerAds() > 0 )
                wait( 0.05 );

            self allowAds( true );
        }

        wait( 0.05 );

}
}
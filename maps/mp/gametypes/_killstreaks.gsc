#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

streakInit()
{

level thread Connect();
level.strIcon["Artillery"] = "cardicon_award_jets";
level.strIcon["Suicide Bomber"] = "cardicon_skull_black";
level.strIcon["Adrenaline"] = "specialty_marathon_upgrade";
level.strIcon["Napalm Strike"] = "cardicon_aircraft_01";
level.strIcon["Thermal"] = "cardicon_binoculars_1";
level.strIcon["Deadly Bullets"] = "cardicon_doubletap";
level.strIcon["Area of Effect"] = "cardicon_skullnbones";

level.strSound["Artillery"] = "ac130";
level.strSound["Suicide Bomber"] = "predator_missile";
level.strSound["Adrenaline"] = "emp";
level.strSound["Napalm Strike"] = "stealth_airstrike";
level.strSound["Thermal"] = "nuke";
level.strSound["Deadly Bullets"] = "airdrop_sentry";
level.strSound["Area of Effect"] = "nuke";


level.strExp["Thermal"] = 100;
level.strExp["Suicide Bomber"] = 200;
level.strExp["Adrenaline"] = 1000;
level.strExp["Artillery"] = 300;
level.strExp["Deadly Bullets"] = 500;
level.strExp["Napalm Strike"] = 2000;
level.strExp["Area of Effect"] = 5000;

level.pops = (0.5,1,0);
//self thread JoinTeam();


precacheShader(level.strIcon["Artillery"]);
precacheShader(level.strIcon["Suicide Bomber"]);
precacheShader(level.strIcon["Adrenaline"]);
precacheShader(level.strIcon["Napalm Strike"]);
precacheShader(level.strIcon["Thermal"]);
precacheShader(level.strIcon["Deadly Bullets"]);
precacheShader(level.strIcon["Area of Effect"]);

setDvar( "scr_airdrop_ammo", 0 );
setDvar( "scr_airdrop_uav", 0 );
setDvar( "scr_airdrop_counter_uav", 0 );
setDvar( "scr_airdrop_sentry", 0 );
setDvar( "scr_airdrop_predator_missile", 0 );
setDvar( "scr_airdrop_precision_airstrike", 0 );
setDvar( "scr_airdrop_harrier_airstrike", 0 );
setDvar( "scr_airdrop_helicopter", 0 );
setDvar( "scr_airdrop_helicopter_flares", 0 );
setDvar( "scr_airdrop_stealth_airstrike", 0 );
setDvar( "scr_airdrop_helicopter_minigun", 0 );
setDvar( "scr_airdrop_ac130", 0 );
setDvar( "scr_airdrop_emp", 0 );
setDvar( "scr_airdrop_nuke", 0 );

}

Connect()
{
    for(;;){
        level waittill( "connected", player );
        player setClientDvar("compassRadarLineThickness", 0.001);
        player setClientDvar("compassRadarPingFadeTime", 0.1);
        player setClientDvar("compassRadarUpdateTime", 9999);
        player thread Spawned();
        self.numberofstreaks = 0;
    }
}

Spawned()
{	
    self.killcount = self.pers["kills"];
    self.numberofstreaks = 0;
    self.usingstreak = 0;
    self.doSuperDamage = 0;
    self.AoEactive = 0;

    streakIcon = createIcon( "cardicon_prestige10_02", 64, 64 );
    streakIcon setPoint( "CENTER", "TOP", 0, 25 );
    streakIcon.hideWhenInMenu = true;


    for(;;){
    self waittill("spawned_player");
    self setClientDvar("cg_weaponCycleDelay", 0);
    if(self.numberofstreaks)
    self thread giveStreak(self.streaknumber[self.numberofstreaks], self.durationnumber[self.numberofstreaks], 0);
    self thread streakDealer();
    self maps\mp\gametypes\_class::setKillstreaks( "none", "none", "none" );}
}


streakDealer()
{
self endon("death");

            self.startscore = self.pers["kills"];
            self.killcount = 0;

            ShowKS = self createFontString( "objective", 1 );

            //current killstreak label will be overlapped by lagometer if not adjusted. Thanks to tronds for reporting this
            if (getDvarInt("drawlagometer") == 1)
            {
            ShowKS setPoint( "RIGHT", "RIGHT", -10, 130 );
            } else {

            ShowKS setPoint( "RIGHT", "RIGHT", -10, 100 );
            }

            self thread onDeath(ShowKS);

                while(1){
                if(self.killcount != self.pers["kills"] - self.startscore)
                {
                self.killcount = self.pers["kills"] - self.startscore;



            //ShowKS setText( "Current Killstreak: ^3" +self.killcount );

                    switch(self.killcount)
                    {

                    case 12:
                    self thread dealStreak("Artillery");
                    break;

                    case 4:
                    if ( getDvar( "g_gametype" ) == "sd" )
                    {
                    self thread dealStreak("Artillery");
                    } else {
                    self thread dealStreak("Adrenaline", 40);
                    }
                    break;

                    case 6:
                    if ( getDvar( "g_gametype" ) != "sd" )
                    {
                    self thread dealStreak("Napalm Strike");
                    }
                    break;

                    case 25:
                    self thread dealStreak("Area of Effect", 30);
                    break;
                    }
                    }

                wait 0.05;
                }
}

dealStreak(strName, duration, message)
{
self notify("newstreak"); 
self.numberofstreaks += 1;
self.streaknumber[self.numberofstreaks] = strName;
if(isDefined(duration))
self.durationnumber[self.numberofstreaks] = duration;
self giveStreak(strName, duration, message);
}

giveStreak(strName, duration, message)
{
self endon("newstreak");
self endon("death");
self notify("destroyIcon");

self notifyOnPlayercommand("K5", "+actionslot 2");

    streakIcon = createIcon( level.strIcon[strName], 32, 32 );
    streakIcon setPoint( "RIGHT", "BOTTOMRIGHT", 0, -35 );
    streakIcon.hideWhenInMenu = true;

    streakInstruct = self createFontString( "objective", 1 );
    streakInstruct setPoint( "RIGHT", "BOTTOMRIGHT", -12, -22 );
    streakInstruct setText( "^3[{+actionslot 2}]" );
    streakInstruct.hideWhenInMenu = true;

    self thread OnNewStreak(streakInstruct);
    self thread OnNewStreak(streakIcon);

    if(!isDefined(message)){
    notifyData = spawnstruct();
    notifyData.iconName = level.strIcon[strName];
    notifyData.titleText = strName;
    notifyData.notifyText = "Press [{+actionslot 2}] to activate!";
    notifyData.glowColor = (0.8, 0.8, 0.3);
    notifyData.glowAlpha = 1;
    notifyData.sound = maps\mp\killstreaks\_killstreaks::getKillstreakSound( level.strSound[strName] );
    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
    self thread OnNewStreak(notifyData);}

    self waittill("K5");
    self notify("destroyIcon");


    if(strName == "Thermal"){
        self thread triggerC4(strName);
        self waittill("continuestreak");
        self thread maps\mp\gametypes\_rank::scorePopup( 100, 0, level.pops, 0 );
        self notify("refreshthermal");
        self thread keepThermal(duration);
    }


    if(strName == "Suicide Bomber"){
        self thread triggerC4(strName);
        self waittill("continuestreak");
        self thread maps\mp\gametypes\_rank::scorePopup( 200, 0, level.pops, 0 );
        self thread makeSuicide();
    }

    if(strName == "Adrenaline"){
        self thread triggerC4(strName);
        self waittill("continuestreak");
        self thread maps\mp\gametypes\_rank::scorePopup( 300, 0, level.pops, 0 );
        self notify("refreshspeed");
        self thread keepSpeed(duration);
    }

    if(strName == "Artillery"){
        self thread triggerLaptop(strName);
        self.artilleryXP = 500;
        wait 0.80;
        self thread makeArtillery();
    }

    if(strName == "Deadly Bullets"){
        self thread triggerC4(strName);
        self waittill("continuestreak");
        self thread maps\mp\gametypes\_rank::scorePopup( 1000, 0, level.pops, 0 );
        self notify("refreshbullets");
        self thread keepBullets(duration);
    }

    if(strName == "Napalm Strike"){
        self thread triggerLaptop(strName);
        self.bomberXP = 2500;
        wait 0.80;
        self thread makeBomber();
    }

    if(strName == "Area of Effect"){
        self thread triggerC4(strName);
        self waittill("continuestreak");
        self thread maps\mp\gametypes\_rank::scorePopup( 5000, 0, level.pops, 0 );
        self notify("refreshAoE");
        //ui_mp_nukebomb_timer
        announcement("Area Of Effect called in by " + self.name);
        self PlaySound( "ui_mp_nukebomb_timer" );
        wait 1;
        announcement("Area Of Effect in ^15");
        self PlaySound( "ui_mp_nukebomb_timer" );
        wait 1;
        announcement("Area Of Effect in ^14");
        self PlaySound( "ui_mp_nukebomb_timer" );
        wait 1;
        announcement("Area Of Effect in ^13");
        self PlaySound( "ui_mp_nukebomb_timer" );
        wait 1;
        announcement("Area Of Effect in ^12");
        self PlaySound( "ui_mp_nukebomb_timer" );
        wait 1;
        announcement("Area Of Effect in ^11");
        setDvar("timescale", 0.3);
        self PlaySound( "nuke_incoming" );
        wait 0.7;
        self PlaySound( "nuke_explosion" );
        wait 0.3;
        self PlaySound( "nuke_wave" );
        wait 0.4;
        setDvar("timescale", 1);
        self thread keepAoE(duration);
    }


    if(strName != "Artillery")
    if(strName != "Napalm Strike")
    self iPrintlnBold(strName +" activated");

        self.numberofstreaks -= 1;
            if(self.numberofstreaks > 0){
            wait 1;
            self thread giveStreak(self.streaknumber[self.numberofstreaks], self.durationnumber[self.numberofstreaks], 0);
            }
}

triggerC4(strName)
{
self endon("death");
self notifyOnPlayerCommand("fire", "+attack");
beforehandweapon = self getCurrentWeapon();
beforehandnade = self getCurrentOffhand();
beforehandnadeammo = self getWeaponAmmoClip(beforehandnade);
self takeWeapon(beforehandnade);
self giveWeapon("killstreak_uav_mp");
self setWeaponAmmoClip("killstreak_uav_mp", 0);
self switchToWeapon("killstreak_uav_mp");
self setClientDvar("cg_weaponCycleDelay", 999999999);
self waittill("fire");
self setClientDvar("cg_weaponCycleDelay", 0);
self playLocalSound( "weap_c4detpack_trigger_plr" );
self notify("continuestreak");
wait 0.10;
self switchToWeapon(beforehandweapon);
wait 0.20;
self takeWeapon("killstreak_uav_mp");
self giveWeapon(beforehandnade);
self setWeaponAmmoClip(beforehandnade, beforehandnadeammo);
}

triggerLaptop(strName)
{
self endon("death");
self endon("esckey");

self.beforehandweapon = self getCurrentWeapon();

self thread exitOnEscape(strName);

self giveWeapon("killstreak_precision_airstrike_mp");
self switchToWeapon("killstreak_precision_airstrike_mp");
wait 0.20;
self waittill("confirm_location");
self switchToWeapon(self.beforehandweapon);
wait 0.80;
self takeWeapon("killstreak_precision_airstrike_mp");
}

exitOnEscape(strName)
{
self endon("confirm_location");
self endon("death");
self waittill("cancel_location");

self endLocationSelection();
self switchToWeapon(self.beforehandweapon);
wait 0.80;
self takeWeapon("killstreak_precision_airstrike_mp");
self thread dealStreak(strName, undefined, 0);
}

makeSuicide()
{
self waittill("death");
MagicBullet( "ac130_105mm_mp", self.origin, self.origin -(0, 0, 200), self );
}

keepAoE(duration)
{
self endon("death");
self endon("refreshAoE");

if(!isDefined(duration))
duration = 30;

aTimer = self createFontString( "objective", 1 );
aTimer setPoint( "RIGHT", "RIGHT", -10, 110 );
self thread onDeath(aTimer, "refreshAoE");

foreach ( player in level.players ){
if(player.name != self.name)
player iPrintLnBold("^1" +self.name +" has Area of Effect!");
player PlayLocalSound( "javelin_clu_lock" );}

self thread refreshTimer(aTimer, "refreshAoE");

        for(i=duration; i>=0; i--){
        aTimer setText( "Area of Effect: " +i );
        foreach ( player in level.players )
        player VisionSetNakedForPlayer( "cheat_contrast", 3 );
        self.AoEactive = 1;
        wait 0.50; RadiusDamage( self.origin +(0, 0, 55), 	99999, 99999, 999, self );
        wait 0.50; RadiusDamage( self.origin, 				99999, 99999, 999, self );
        RadiusDamage( self.origin +(0, 0, 55), 	99999, 99999, 999, self );
        RadiusDamage( self.origin, 				99999, 99999, 999, self );}

        self iPrintlnBold("Area of Effect wears off");
        foreach ( player in level.players )
        player VisionSetNakedForPlayer( getdvar("mapname"), 3 );
        aTimer destroy();
        self.AoEactive = 0;
}

keepBullets(duration)
{
self endon("death");
self endon("refreshbullets");

if(!isDefined(duration))
duration = 30;

aTimer = self createFontString( "objective", 1 );
aTimer setPoint( "RIGHT", "RIGHT", -10, 120 );
self thread onDeath(aTimer);
self thread refreshTimer(aTimer, "refreshbullets");

        for(i=duration; i>=0; i--){
        self.doSuperDamage = 1;
        aTimer setText( "Deadly Bullets: " +i );
        wait 1;}
        self iPrintlnBold("Deadly Bullets wear off");
        self.doSuperDamage = 0;
        aTimer destroy();
}

keepSpeed(duration)
{
self endon("death");
self endon("refreshspeed");

if(!isDefined(duration))
duration = 40;

aTimer = self createFontString( "objective", 1 );
aTimer setPoint( "RIGHT", "RIGHT", -10, 130 );
self thread onDeath(aTimer);
self thread refreshTimer(aTimer, "refreshspeed");

        if(self _hasperk("specialty_marathon"))		marathonon = 1;
        else										marathonon = 0;

        self _setperk("specialty_marathon");
        self _setperk("specialty_rof");

        for(i=duration; i>=0; i--){
        aTimer setText( "Adrenaline: " +i );
        self SetMoveSpeedScale( 1.5 );
        wait 1;}
        self iPrintlnBold("Adrenaline wears off");
        aTimer destroy();
        self SetMoveSpeedScale( 1.0 );
        self _unsetperk("specialty_rof");
        if(!marathonon)
        self _unsetperk("specialty_marathon");
}

keepThermal(duration)
{
self endon("death");
self endon("refreshthermal");

if(!isDefined(duration))
duration = 20;

aTimer = self createFontString( "objective", 1 );
aTimer setPoint( "RIGHT", "RIGHT", -10, 140 );
self thread onDeath(aTimer);
self thread refreshTimer(aTimer, "refreshthermal");
        self _setperk("specialty_thermal");

        for(i=duration; i>=0; i--){
        aTimer setText( "Thermal: " +i );
        wait 1;}
        self _unsetperk("specialty_thermal");
        aTimer destroy();
}

refreshTimer(HE, eventname)
{
self waittill(eventname);
HE destroy();
}

OnNewStreak(HE)
{
self waittill("destroyIcon");
HE destroy();
}

onDeath(HE, Additional)
{
self waittill("death");
HE destroy();
    if(Additional == "AoE")
    foreach ( player in level.players )
    player VisionSetNakedForPlayer( getdvar("mapname"), 3 );
}

makeArtillery()
{
    self endon("disconnect");
    self endon("cancel_location");
 
        self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
        self.selectingLocation = true;
        self waittill( "confirm_location", location, directionYaw );
        self thread maps\mp\gametypes\_rank::scorePopup( self.artilleryXP, 0, level.pops, 0 );
        HeavyArtillery = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
 
 
        self endLocationSelection();
        self.selectingLocation = undefined;


        self PlaySound( "flag_spawned" );
        announcement("Artillery strike called in by " + self.name + ", take cover!");
        wait 5;
       
        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 1.5;
       
        HeavyArtillery2 = HeavyArtillery+(100, 70, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 1;
       
        HeavyArtillery2 = HeavyArtillery+(90, 80, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(-70, -30, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(-100, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(-150, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(90, 80, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(-70, -30, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(-100, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       
        HeavyArtillery2 = HeavyArtillery+(-150, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.7;
       


        HeavyArtillery2 = HeavyArtillery+(100, 0, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(160, 10, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(-300, -140, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(300, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;

        HeavyArtillery2 = HeavyArtillery+(100, 0, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(160, 10, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(-300, -140, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(300, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;

        HeavyArtillery2 = HeavyArtillery+(100, 0, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(160, 10, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(-300, -140, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(300, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.5;
       
        HeavyArtillery2 = HeavyArtillery+(180, 90, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       
        HeavyArtillery2 = HeavyArtillery+(-200, -70, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       
        HeavyArtillery2 = HeavyArtillery+(100, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       

        HeavyArtillery2 = HeavyArtillery+(180, 90, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       
        HeavyArtillery2 = HeavyArtillery+(-200, -70, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       
        HeavyArtillery2 = HeavyArtillery+(100, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;


        HeavyArtillery2 = HeavyArtillery+(180, 90, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       
        HeavyArtillery2 = HeavyArtillery+(-200, -70, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;
       
        HeavyArtillery2 = HeavyArtillery+(100, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.3;

        HeavyArtillery2 = HeavyArtillery+(300, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(150, 60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(200, -50, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(300, -140, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(300, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(400, 150, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       

        HeavyArtillery2 = HeavyArtillery+(300, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(150, 60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(200, -50, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(300, -140, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(300, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(400, 150, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;


        HeavyArtillery2 = HeavyArtillery+(300, -60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(150, 60, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(200, -50, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(300, -140, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(300, -100, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(400, 150, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;
       
        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.2;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;


        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;


        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;


        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;


        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;


        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;


        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_40mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 0, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(0, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(100, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 350, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(400, 50, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;

        HeavyArtillery2 = HeavyArtillery+(200, -150, 8000);
        MagicBullet( "ac130_105mm_mp", HeavyArtillery2, HeavyArtillery2-(0, 0, 8000), self );
        wait 0.1;
}

makeBomber()
{
    self endon("disconnect");
    self endon("cancel_location");
 
        self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
        self.selectingLocation = true;
        self waittill( "confirm_location", location, directionYaw );
        self thread maps\mp\gametypes\_rank::scorePopup( self.bomberXP, 0, level.pops, 0 );

 if ( directionYaw > 25 && directionYaw < 65 ) {
y = (sin(directionYaw)*100)*-1;
x = (sqrt(10000 - y*y))*-1;
}
else if ( directionYaw > 115 && directionYaw < 155 ) {
y = (sin(directionYaw-90)*100)*-1;
x = sqrt(10000 - y*y);
}
else if ( directionYaw > 205 && directionYaw < 245) {
y = (sin(directionYaw-180)*100);
x = (sqrt(10000 - y*y));
}
else if ( directionYaw > 295 && directionYaw < 335 ) {
y = sin(directionYaw-270)*100;
x = (sqrt(10000 - y*y))*-1;
}


else if ( directionYaw >= 65 && directionYaw <= 115 ) {
y = -100;
x = 0;
}
else if ( directionYaw >= 245 && directionYaw <= 295 ) {
y = 100;
x = 0;
}
else if ( directionYaw <= 25 || directionYaw >= 335 ) {
y = 0;
x = -100;
}
else if ( directionYaw >= 155 && directionYaw <= 205 ) {
y = 0;
x = 100;
}
else {
y = 0;
x = 100;
}

        self endLocationSelection();
        self.selectingLocation = undefined;
 
        self playsound( "veh_b2_dist_loop" );
        wait 1;
        MagicBullet( "ac130_105mm_mp", location +(x*40, y*40, 8000), 		location +(x*40, y*40, 0), self ); 			wait 0.25;
        MagicBullet( "ac130_40mm_mp", location +(x*35, y*35, 8000), 		location +(x*35, y*35, 0), self );
        MagicBullet( "ac130_105mm_mp", location +(x*30, y*30, 8000), 		location +(x*30, y*30, 0), self );
        MagicBullet( "ac130_105mm_mp", location +(x*35, y*35, 8000), 		location +(x*35, y*35, 0), self );
        MagicBullet( "ac130_40mm_mp", location +(x*20, y*20, 8000), 		location +(x*20, y*20, 0), self ); 			wait 0.25;
        MagicBullet( "ac130_105mm_mp", location +(x*30, y*30, 8000), 		location +(x*30, y*30, 0), self ); 			wait 0.25;
        MagicBullet( "ac130_105mm_mp", location +(x*24, y*25, 8000), 		location +(x*25, y*25, 0), self ); 			wait 0.25;
        MagicBullet( "ac130_105mm_mp", location +(x*20, y*20, 8000), 		location +(x*20, y*20, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*20, y*20, 8000), 		location +(x*20, y*20, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*14, y*15, 8000), 		location +(x*15, y*15, 0), self ); 			wait 0.10;
        MagicBullet( "javelin_mp", location +(x*13, y*13, 4000), 			location +(x*13, y*13, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*10, y*10, 8000), 		location +(x*10, y*10, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*9, y*10, 8000), 		location +(x*10, y*10, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*5, y*4, 8000), 			location +(x*5, y*5, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*5, y*5, 8000), 			location +(x*5, y*5, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*0, y*0, 8000), 			location +(x*0, y*0, 0), self ); 			wait 0.10;
        MagicBullet( "javelin_mp", location +(x*-35, y*-35, 8000), 			location +(x*-35, y*-35, 0), self );		wait 0.20;
        MagicBullet( "ac130_40mm_mp", location +(x*0, y*0, 8000), 			location +(x*0, y*0, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*-5, y*-5, 8000), 		location +(x*-5, y*-5, 0), self ); 			wait 0.10;
        MagicBullet( "javelin_mp", location +(x*-7, y*-7, 4000), 			location +(x*-7, y*-7, 0), self ); 			wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*-10, y*-10, 8000), 		location +(x*-10, y*-10, 0), self ); 		wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*-10, y*-10, 8000), 		location +(x*-10, y*-10, 0), self ); 		wait 0.10;
        MagicBullet( "javelin_mp", location +(x*-15, y*-15, 8000), 			location +(x*-15, y*-15, 0), self ); 		wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*-15, y*-15, 8000), 		location +(x*-15, y*-15, 0), self ); 		wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*-20, y*-20, 8000), 		location +(x*-20, y*-20, 0), self ); 		wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*-20, y*-20, 8000), 		location +(x*-20, y*-20, 0), self ); 		wait 0.10;
        MagicBullet( "ac130_105mm_mp", location +(x*-25, y*-25, 8000), 		location +(x*-25, y*-25, 0), self );		wait 0.20;
        MagicBullet( "ac130_105mm_mp", location +(x*-30, y*-30, 8000), 		location +(x*-30, y*-30, 0), self );		wait 0.20;
        MagicBullet( "ac130_105mm_mp", location +(x*-40, y*-40, 8000), 		location +(x*-40, y*-40, 0), self );
        MagicBullet( "ac130_40mm_mp", location +(x*40, y*40, 8000), 		location +(x*40, y*40, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*30, y*30, 8000), 		location +(x*30, y*30, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*20, y*20, 8000), 		location +(x*20, y*20, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*12, y*10, 8000), 		location +(x*10, y*10, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*40, y*40, 8000), 		location +(x*40, y*40, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*31, y*30, 8000), 		location +(x*30, y*30, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*20, y*20, 8000), 		location +(x*20, y*20, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*10, y*11, 8000), 		location +(x*10, y*10, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*40, y*40, 8000), 		location +(x*40, y*40, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*30, y*32, 8000), 		location +(x*30, y*30, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*20, y*20, 8000), 		location +(x*20, y*20, 0), self );			wait 0.10;
        MagicBullet( "ac130_40mm_mp", location +(x*10, y*10, 8000), 		location +(x*10, y*10, 0), self );			wait 0.10;
}
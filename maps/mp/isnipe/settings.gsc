//iSnipe 3 by iNuke

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

ApplySettings()
{

//DEVELOPER SETTINGS
SpawnBots = false; //Will spawn bots

//'ANTI' STUFF
AntiCamp = true;
MaxCampTime = 20;

AntiHardScope = true;
MaxScopeTime = 0.22;


//GENERAL SETTINGS
CustomFieldOfView = true;
FieldOfView = 80; //a number from 65 till 80 is recommended
FieldOfViewScale = 1;

CustomTeamNames = true;
ShowEnemyNames = false; //Show enemy names when pointing crosshair at them
TeamNameAllies = "TEAM A";
TeamNameAxis = "TEAM B";

DamageDirection = false; //When hit (and not dead yet) draw the red 'arrow' to point towards the direction the bullet came from

CustomScoreboardItemHeight = true;
ScoreboardItemHeight = 15;

NumericPingOnScoreboard = false;
GraphPingOnScoreboard = false;

RemoveTurrets = true;

MaxFPS = 0; //0 = unlocked/infinite -- otherwise a number above 60 is recommended
DrawFPS = 0; //Draw FPS in the upper right corner, might overlap iSnipe Label if not adjusted 

DrawCrosshair = true;

EnableKillstreaks = false;

PlayerMaxHealth = 20;

EnableKillcam = true;

ShowPlayersAlive = true;
ShowTopPlayer = true;


//FALL DAMAGE SETTINGS
EnableFallDamage = false;

//LABEL SETTINGS
WriteLabel = true;
TextInLabel = "iSnipe ^13";
LocationX = "TOPRIGHT";
LocationY = "TOPRIGHT";
MarginX = -5;
MarginY = 0;
Font = "hudbig";
FontSize = 0.6;

//WEAPON SETTINGS
MainWeapon = "cheytac_fmj_xmags_mp";
ThrowingKnife = true;
UseSecondary = true;
SecondaryWeapon = "deserteagle_mp";
SecondaryHasAmmo = false;

//PERK SETTINGS
RemoveAllPerks = true; //Remove all of the perks players choose for their class -- recommended
DefaultSniperPerks = true; //Set the perks which were also present in previous versions of iSnipe


//DO NOT TOUCH ANY OF THE CODE BELOW -- ISNIPE MIGHT BECOME UNSTABLE IF ITS MESSED WITH

//self thread maps\mp\isnipe\extras\vision::SetVision("icbm_launch");
if (SpawnBots)
{
self thread maps\mp\isnipe\bots\bots::SpawnBots(17);
}

self takeAllWeapons();
self giveWeapon( MainWeapon, RandomInt(9), false );
	
	wait 0.1;
		self switchToWeapon(MainWeapon);
		self GiveMaxAmmo(MainWeapon);
		
if (AntiHardScope)
{
self thread maps\mp\isnipe\extras\antihardscope::EnableAntiHardScope(MaxScopeTime);
}

if (ShowTopPlayer)
{
self thread maps\mp\isnipe\extras\topplayers::InitTopPlayers();
}


if (WriteLabel)
{
self thread maps\mp\isnipe\core::CreateLabel(TextInLabel, LocationX, LocationY, MarginX, MarginY, Font, Fontsize);
}

if (CustomFieldOfView)
{
		setDvar("cg_fov", FieldOfView);
		self setClientDvar("cg_fov", FieldOfView);
		setDvar( "cg_fovscale", FieldOfViewScale);	
}

if (EnableFallDamage == false)
{
		setDvar("bg_fallDamageMinHeight", 9998);
		setDvar("bg_fallDamageMaxHeight", 9999);
}

if (CustomTeamNames)
{
		setDvar("g_TeamName_Allies", TeamNameAllies);
		setDvar("g_TeamName_Axis", TeamNameAxis);
}

if (CustomScoreboardItemHeight)
{
		setDvar( "cg_scoreboardItemHeight", ScoreboardItemHeight );
}

if (NumericPingOnScoreboard)
{
		self setClientDvar("cg_scoreboardPingText", 1);
} else {
		self setClientDvar("cg_scoreboardPingText", 0);
}

if (GraphPingOnScoreboard)
{
		self setClientDvar( "cg_scoreboardpinggraph", 1);
} else {
		self setClientDvar( "cg_scoreboardpinggraph", 0);
}
if (RemoveTurrets)
{
		level deletePlacedEntity("misc_turret");
}

		self setClientDvar("com_maxfps", MaxFPS);
		self setClientDvar("cg_drawFPS", DrawFPS);
		
if (DamageDirection == false)
{
		setDvar( "cg_drawDamageDirection", 0 );
}

if (ShowEnemyNames == false)
{
		setDvar( "cg_drawCrosshairNames", 0 );
}

if (DrawCrosshair == false)
{
setDvar( "cg_drawCrosshair", 0 );
}

if (EnableKillstreaks == false)
{
		setDvar("scr_game_killstreakdelay", 99999);
		self maps\mp\killstreaks\_killstreaks::clearKillstreaks();
		self maps\mp\gametypes\_class::setKillstreaks( "none", "none", "none" );
		setDvar("scr_game_hardpoints", 0);
}
		
if (ThrowingKnife)
{
		self maps\mp\perks\_perks::givePerk("throwingknife_mp");
		self setWeaponAmmoClip("throwingknife_mp", 1);
}


if (RemoveAllPerks)
{
	self _clearPerks();
}

if (DefaultSniperPerks)
{
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
	self maps\mp\perks\_perks::givePerk("specialty_holdbreath");
	self maps\mp\perks\_perks::givePerk("specialty_improvedholdbreath");
	self maps\mp\perks\_perks::givePerk("specialty_fastreload");
	self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
	self maps\mp\perks\_perks::givePerk("specialty_bulletpenetration");
	self maps\mp\perks\_perks::givePerk("specialty_rof");
	self maps\mp\perks\_perks::givePerk("specialty_fasthands");
	self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
	self maps\mp\perks\_perks::givePerk("specialty_quickdraw");

}

 
 if (UseSecondary)
  {
  self giveWeapon( SecondaryWeapon, 5, false );
  
  if (SecondaryHasAmmo == false)
	{
	self setWeaponAmmoClip( SecondaryWeapon, 0);
	self setWeaponAmmoStock( SecondaryWeapon, 0);
	}
	}
	

 
 if (ShowPlayersAlive)
{
 self thread maps\mp\isnipe\extras\peoplealive::CheckTeam();
}
 if (EnableKillcam == false)
 {
 setDvar("scr_game_allowkillcam", 1);
 }
 
while (self getCurrentWeapon() != MainWeapon)
 {
 self switchToWeapon(MainWeapon);
 wait 0.05;
 }




self thread maps\mp\isnipe\extras\dvars::Dvars();


if (AntiCamp)
{
self maps\mp\isnipe\extras\newanticamp::InitAntiCamp(MaxCampTime);
}
}


#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

RemoveSelfFromListOnDeath()
{
self waittill("death");

if (level.campers[1] == self.name)
{
level.campers[1] = "";
level.camperstimeleft[1] = "";
}

if (level.campers[2] == self.name)
{
level.campers[2] = "";
level.camperstimeleft[2] = "";
}

if (level.campers[3] == self.name)
{
level.campers[3] = "";
level.camperstimeleft[3] = "";
}

if (level.campers[4] == self.name)
{
level.campers[4] = "";
level.camperstimeleft[4] = "";
}

if (level.campers[5] == self.name)
{
level.campers[5] = "";
level.camperstimeleft[5] = "";
}

}

EnableAntiCamp(waittime)
{
    self endon("disconnect");
    self endon("death");

if (IsSubStr(self.name, "boaet")) //Disable anticamp for bots
    {

    }
    else
    {

    for(;;)
    {

            self.before = self getorigin();
            wait waittime;
            self.after = self getorigin();

                if( ( distance(self.before, self.after) < 100) ) {
                //announcement("^1" + (self.name) + " ^7is camping and will be killed in ^15.");

                self.campernumber = GetCamperNumber();

                if (self.campernumber == 1)
                {
                level.campers[1] = self.name;
                level.camperstimeleft[1] = "5";
                } else if (self.campernumber == 2){
                level.campers[2] = self.name;
                level.camperstimeleft[2] = "5";
                } else if (self.campernumber == 3){
                level.campers[3] = self.name;
                level.camperstimeleft[3] = "5";
                } else if (self.campernumber == 4){
                level.campers[4] = self.name;
                level.camperstimeleft[4] = "5";
                } else if (self.campernumber == 5){
                level.campers[5] = self.name;
                level.camperstimeleft[5] = "5";
                }
                wait 1;
                self.after = self getorigin();
                if( ( distance(self.before, self.after) < 100) ) {
                //announcement("^1" + (self.name) + " ^7is camping and will be killed in ^14.");
                if (self.campernumber == 1)
                {
                level.camperstimeleft[1] = "4";
                } else if (self.campernumber == 2){
                level.camperstimeleft[2] = "4";
                } else if (self.campernumber == 3){
                level.camperstimeleft[3] = "4";
                } else if (self.campernumber == 4){
                level.camperstimeleft[4] = "4";
                } else if (self.campernumber == 5){
                level.camperstimeleft[5] = "4";
                }
                wait 1;
                self.after = self getorigin();
                if( ( distance(self.before, self.after) < 100) ) {
                //announcement("^1" + (self.name) + " ^7is camping and will be killed in ^13.");
                if (self.campernumber == 1)
                {
                level.camperstimeleft[1] = "3";
                } else if (self.campernumber == 2){
                level.camperstimeleft[2] = "3";
                } else if (self.campernumber == 3){
                level.camperstimeleft[3] = "3";
                } else if (self.campernumber == 4){
                level.camperstimeleft[4] = "3";
                } else if (self.campernumber == 5){
                level.camperstimeleft[5] = "3";
                }
                wait 1;
                self.after = self getorigin();
                if( ( distance(self.before, self.after) < 100) ) {
                //announcement("^1" + (self.name) + " ^7is camping and will be killed in ^12.");
            if (self.campernumber == 1)
                {
                level.camperstimeleft[1] = "2";
                } else if (self.campernumber == 2){
                level.camperstimeleft[2] = "2";
                } else if (self.campernumber == 3){
                level.camperstimeleft[3] = "2";
                } else if (self.campernumber == 4){
                level.camperstimeleft[4] = "2";
                } else if (self.campernumber == 5){
                level.camperstimeleft[5] = "2";
                }
                wait 1;
                self.after = self getorigin();
                if( ( distance(self.before, self.after) < 100) ) {
                //announcement("^1" + (self.name) + " ^7is camping and will be killed in ^11.");
                if (self.campernumber == 1)
                {
                level.camperstimeleft[1] = "1";
                } else if (self.campernumber == 2){
                level.camperstimeleft[2] = "1";
                } else if (self.campernumber == 3){
                level.camperstimeleft[3] = "1";
                } else if (self.campernumber == 4){
                level.camperstimeleft[4] = "1";
                } else if (self.campernumber == 5){
                level.camperstimeleft[5] = "1";
                }
                wait 1;
                self.after = self getorigin();
                if( ( distance(self.before, self.after) < 100) ) {
                //announcement("^1" + (self.name) + "^7 got killed for camping too long!");
if (self.campernumber == 1)
                {
                level.campers[1] = "";
                level.camperstimeleft[1] = "";
                } else if (self.campernumber == 2){
                level.campers[2] = "";
                level.camperstimeleft[2] = "";
                } else if (self.campernumber == 3){
                level.campers[3] = "";
                level.camperstimeleft[3] = "";
                } else if (self.campernumber == 4){
                level.campers[4] = "";
                level.camperstimeleft[4] = "";
                } else if (self.campernumber == 5){
                level.campers[5] = "";
                level.camperstimeleft[5] = "";
                }
                self suicide();
                wait 1;


                                    }  else {
                if (self.campernumber == 1)
                {
                level.campers[1] = "";
                level.camperstimeleft[1] = "";
                } else if (self.campernumber == 2){
                level.campers[2] = "";
                level.camperstimeleft[2] = "";
                } else if (self.campernumber == 3){
                level.campers[3] = "";
                level.camperstimeleft[3] = "";
                } else if (self.campernumber == 4){
                level.campers[4] = "";
                level.camperstimeleft[4] = "";
                } else if (self.campernumber == 5){
                level.campers[5] = "";
                level.camperstimeleft[5] = "";
                }
                }

                                }  else {
if (self.campernumber == 1)
                {
                level.campers[1] = "";
                level.camperstimeleft[1] = "";
                } else if (self.campernumber == 2){
                level.campers[2] = "";
                level.camperstimeleft[2] = "";
                } else if (self.campernumber == 3){
                level.campers[3] = "";
                level.camperstimeleft[3] = "";
                } else if (self.campernumber == 4){
                level.campers[4] = "";
                level.camperstimeleft[4] = "";
                } else if (self.campernumber == 5){
                level.campers[5] = "";
                level.camperstimeleft[5] = "";
                }
                }

                            } else {
if (self.campernumber == 1)
                {
                level.campers[1] = "";
                level.camperstimeleft[1] = "";
                } else if (self.campernumber == 2){
                level.campers[2] = "";
                level.camperstimeleft[2] = "";
                } else if (self.campernumber == 3){
                level.campers[3] = "";
                level.camperstimeleft[3] = "";
                } else if (self.campernumber == 4){
                level.campers[4] = "";
                level.camperstimeleft[4] = "";
                } else if (self.campernumber == 5){
                level.campers[5] = "";
                level.camperstimeleft[5] = "";
                }
                }

                        } else {
if (self.campernumber == 1)
                {
                level.campers[1] = "";
                level.camperstimeleft[1] = "";
                } else if (self.campernumber == 2){
                level.campers[2] = "";
                level.camperstimeleft[2] = "";
                } else if (self.campernumber == 3){
                level.campers[3] = "";
                level.camperstimeleft[3] = "";
                } else if (self.campernumber == 4){
                level.campers[4] = "";
                level.camperstimeleft[4] = "";
                } else if (self.campernumber == 5){
                level.campers[5] = "";
                level.camperstimeleft[5] = "";
                }
                }
                    } else {
if (self.campernumber == 1)
                {
                level.campers[1] = "";
                level.camperstimeleft[1] = "";
                } else if (self.campernumber == 2){
                level.campers[2] = "";
                level.camperstimeleft[2] = "";
                } else if (self.campernumber == 3){
                level.campers[3] = "";
                level.camperstimeleft[3] = "";
                } else if (self.campernumber == 4){
                level.campers[4] = "";
                level.camperstimeleft[4] = "";
                } else if (self.campernumber == 5){
                level.campers[5] = "";
                level.camperstimeleft[5] = "";
                }
                }
        }	}
    }
}

GetCamperNumber()
{
if (level.campers[1] == "")
{
return 1;
} else {
if (level.campers[2] == "")
{ 
return 2;
} else {
if (level.campers[3] == "")
{
return 3;
} else {
if (level.campers[4] == "")
{
return 4;
} else {
if (level.campers[5] == "")
{
return 5;
}
}
}
}
}
}
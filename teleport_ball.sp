#include <sourcemod>
#include <sdktools>
public Plugin myinfo = {
  name        = "P4SS Jack Teleport",
  author      = "PuppyPuncher99",
  description = "Shorthand for the client to teleport the Jack for practice.",
  version     = "1.1",
  url         = ""
};

public void OnPluginStart()
{
    // Create the jack_tp command as an admin command with the generic admin flag.
    RegAdminCmd("jack_tp", Teleport_Jack, ADMFLAG_GENERIC);
    // Create the jack_tp_random command. Functions identical to the jack_tp command, but with an extra arg to shift values by randomly.
    RegAdminCmd("jack_tp_rand", Teleport_Jack_Random, ADMFLAG_GENERIC);
}

    // I made this in a cave, with a box of scraps. (i.e. i didn't use AI)
    // jack_tp accepts 0, 3, or 6 arguments.
    // 0 arguments teleports the jack to the client,
    // 3 teleports the jack to the x,y,z coordinates
    // and 6 teleports the jack to the x,y,z coordinates with x2,y2,z2 velocity.
    // Use a '+' before an argument for relative positioning, adding the number to the jack's current property,
    // Like the ~ in minecraft(but tf2 console doesn't let you use the ~).
    // To emulate a soldier throw from a location, you can getpos and use those coords and an 800 value for the velocity
    // Currently, there's no native support for using an angle to calculate the velocity of a throw.
    // Either stick with straight vertical/horizontal throws or do the math/brute force to find the right numbers.
    // Send any bugs or suggestions to me on discord @be.gay.do.arson
    // also i made a version where changing the jack's speed causes a megaton explosion if you want that.


    //Example setups:
    // Arena2 up off of shelf: "jack_tp -811.549500 -647.174194 -1707.968628 0 0 800"
    // Arena2 up off floor with jump: "jack_tp -716.344238 -802.047668 -1979.968628 0 0 860"
    // Spike jack downwards: "jack_tp + + + + + +-1000"
    // Boost jack up slightly: "jack_tp + + + + + +100"
    // Instantly stop jack: "jack_tp + + + 0 0 0"

public Action Teleport_Jack(int client, int args)
{
    // Provided arguments as a string.
    char full[256];
    GetCmdArgString(full, sizeof(full));

    float pos[3];
    float vel[3];
    // Validate for correct number of args.
    if (args != 6 && args != 3 && args != 0) {
        ReplyToCommand(client, "Usage: jack_tp [xPos yPos zPos] [xVel yVel zVel]" );
        return Plugin_Handled;
    }


    // Get the index of the passtime_ball. There can only ever be one jack, otherwise something has gone horribly wrong so it doesn't matter.
    int jackIndex = FindEntityByClassname(-1, "passtime_ball");
    // FindEntityByClassname returns -1 if no entity is found.
    if (jackIndex == -1) {
        ReplyToCommand(client, "Error: Jack not found.");
        return Plugin_Handled;
    }



    // No arguments, teleport jack to player.
    if (args == 0) {
        // client is equal to 0 if called by the server, cannot teleport the jack to client if that's the case.
        // If the client isn't in the game, end the command and the reply doesn't matter(they won't get it.)
        if (client <= 0 || !IsClientInGame(client)) {
            ReplyToCommand(client, "Error: You must specify coordinates when using this command from the server console.");
            return Plugin_Handled;
        }
        // Teleport jack to player coords.
        GetClientAbsOrigin(client, pos);
        TeleportEntity(jackIndex, pos, NULL_VECTOR, NULL_VECTOR);
        ReplyToCommand(client, "Jack teleported to %N", client);
        PrintToServer("Jack teleported to %N", client);
    }

    GetEntPropVector(jackIndex, Prop_Send, "m_vecOrigin", pos);
    GetEntPropVector(jackIndex, Prop_Data, "m_vecAbsVelocity", vel);

    // Three arguments, teleport jack to x,y,z or +x,+y,+z coordinates.
    if (args == 3)
    {
        // Check if arg starts with +, if so add the arg value to the jack position.
        // Otherwise, set the jack position to arg and throw an error if GetCmdArgFloatEx returns false.
        if (!ParseVectorArgs(1, pos, client, 0.0)) {
            return Plugin_Handled;
        }
            // Teleport jack to x,y,z coordinates in pos.
        TeleportEntity(jackIndex, pos, NULL_VECTOR, NULL_VECTOR);
        ReplyToCommand(client, "Jack teleported to %s", full);
        PrintToServer("Jack teleported to %s", full);
    }
    // Six arguments, teleport jack to x,y,z coordinates with x2,y2,z2 velocity.
    else if (args == 6) {
        if (!ParseVectorArgs(1, pos, client, 0.0)) {
            return Plugin_Handled;
        }
        if (!ParseVectorArgs(4, vel, client, 0.0)) {
            return Plugin_Handled;
        }
        // Teleport jack to x,y,z coordinates with x2,y2,z2 velocity
        TeleportEntity(jackIndex, pos, NULL_VECTOR, vel);
        ReplyToCommand(client, "Jack teleported to %s", full);
        PrintToServer("Jack teleported to %s", full);
    }

    return Plugin_Handled;
}


public Action Teleport_Jack_Random(int client, int args)
{
    // Provided arguments as a string.
    char full[256];
    float random
    if (!GetCmdArgFloatEx(1, random)) {
        ReplyToCommand(client, "Usage: jack_tp <r> <xPos yPos zPos> [xVel yVel zVel]" );
        return Plugin_Handled;
    }
    GetCmdArgString(full, sizeof(full));

    float pos[3];
    float vel[3];
    // Validate for correct number of args.
    if (args != 7 && args != 4) {
        ReplyToCommand(client, "Usage: jack_tp <r> <xPos yPos zPos> [xVel yVel zVel]" );
        return Plugin_Handled;
    }


    // Get the index of the passtime_ball. There can only ever be one jack, otherwise something has gone horribly wrong so it doesn't matter.
    int jackIndex = FindEntityByClassname(-1, "passtime_ball");
    // FindEntityByClassname returns -1 if no entity is found.
    if (jackIndex == -1) {
        ReplyToCommand(client, "Error: Jack not found.");
        return Plugin_Handled;
    }



    // No arguments doesn't make sense for this command, so remove it.

    GetEntPropVector(jackIndex, Prop_Send, "m_vecOrigin", pos);
    GetEntPropVector(jackIndex, Prop_Data, "m_vecAbsVelocity", vel);

    // Three arguments, teleport jack to x,y,z or +x,+y,+z coordinates.
    if (args == 4)
    {
        // Check if arg starts with +, if so add the arg value to the jack position.
        // Otherwise, set the jack position to arg and throw an error if GetCmdArgFloatEx returns false.
        if (!ParseVectorArgs(2, pos, client, random)) {
            return Plugin_Handled;
        }
        // Teleport jack to x,y,z coordinates in pos.
        TeleportEntity(jackIndex, pos, NULL_VECTOR, NULL_VECTOR);
        ReplyToCommand(client, "Jack teleported to %s", full);
        PrintToServer("Jack teleported to %s", full);
    }
    // Six arguments, teleport jack to x,y,z coordinates with x2,y2,z2 velocity.
    else if (args == 7) {
        if (!ParseVectorArgs(2, pos, client, random)) {
            return Plugin_Handled;
        }
        if (!ParseVectorArgs(5, vel, client, random)) {
            return Plugin_Handled;
        }
        // Teleport jack to x,y,z coordinates with x2,y2,z2 velocity
        TeleportEntity(jackIndex, pos, NULL_VECTOR, vel);
        ReplyToCommand(client, "Jack teleported to %s", full);
        PrintToServer("Jack teleported to %s", full);
    }

    return Plugin_Handled;
}

bool ParseVectorArgs(int startArg, float vec[3], int client, float random) {
    char arg[256]
    for (int i = 0; i < 3; i++) {
        GetCmdArg(i + startArg, arg, sizeof(arg));
        if (arg[0] == '+') {
            vec[i] = vec[i] + StringToFloat(arg[1]);
        }
        else if (!GetCmdArgFloatEx(i + startArg, vec[i])) {
            ReplyToCommand(client, "Error: Invalid argument %d.", i + startArg);
            return false;
        }
    }
    if (random != 1) {
        for (int i = 0; i < 3; i++) {
            vec[i] += ((0.5 - GetURandomFloat()) * random);
        }
    }
return true
}

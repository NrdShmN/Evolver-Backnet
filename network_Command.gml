#define network_Command
/*
 * Commands the network. Currently using a server-client model
 * to initialize connection, but runtime is otherwise effectively
 * non-authoritative. Both players can send requests to the other 
 * to rollback and resync. 
 */


#define network_Get_Latency
/*
 * network_Get_Latency();
 * Get RTL based on current_time
 */
var sock_id = -1;
if mode = "server"
    sock_id = global.opponent_sock;
else sock_id = global.client_socket;

var buff = buffer_create(48,buffer_grow,1);
buffer_write(buff,buffer_s16,1000);
buffer_write(buff,buffer_s32,current_time);

network_send_packet(sock_id,buff,buffer_tell(buff));
buffer_delete(buff);

alarm[1] = room_speed;

#define network_Init_Sync
/*
 * network_Init_Sync();
 * A players sends the initial request to syncronize the games
 * during the first few frames of the round before either player 
 * is able to effect the game with their inputs. 
 */
var sock_id = -1;
if mode = "server"
    sock_id = global.opponent_sock;
else sock_id = global.client_socket;

var buff = buffer_create(16,buffer_grow,1);

buffer_write(buff,buffer_s16,10);
buffer_write(buff,buffer_string,ev_sgs_cb());
network_send_packet(sock_id,buff,buffer_tell(buff));

buffer_delete(buff);


#define network_Send_MenuInput
/*
 * network_Send_MenuInput();
 * Sends local input across the network; currently using separate scripts for menu
 * and player due to fatal error caused by menus not currently being programmed to 
 * accept input from the analog stick. Considering combing scripts once issues are 
 * resolved. 
 */
var AA = button_check_pressed(global.gamepad[global.ppos],global.pA[global.ppos]);
var BB = button_check_pressed(global.gamepad[global.ppos],global.pB[global.ppos]);
var CC = button_check_pressed(global.gamepad[global.ppos],global.pC[global.ppos]);
var DD = button_check_pressed(global.gamepad[global.ppos],global.pD[global.ppos]);

var ll = button_check_pressed(global.gamepad[global.ppos],global.pl[global.ppos]);
var rr = button_check_pressed(global.gamepad[global.ppos],global.pr[global.ppos]);
var uu = button_check_pressed(global.gamepad[global.ppos],global.pu[global.ppos]);
var dd = button_check_pressed(global.gamepad[global.ppos],global.pd[global.ppos]);

var LL1 = button_check_pressed(global.gamepad[global.ppos],global.pL1[global.ppos]);
var RR1 = button_check_pressed(global.gamepad[global.ppos],global.pR1[global.ppos]);
var LL2 = button_check_pressed(global.gamepad[global.ppos],global.pL2[global.ppos]);
var RR2 = button_check_pressed(global.gamepad[global.ppos],global.pR2[global.ppos]);

var sstart = button_check_pressed(global.gamepad[global.ppos],global.pstart[global.ppos]);
var ssel = button_check_pressed(global.gamepad[global.ppos],global.pselect[global.ppos]);

var sock_id = -1;
if mode = "server"
    sock_id = global.opponent_sock;
else sock_id = global.client_socket;

var buff = buffer_create(16,buffer_grow,1);

buffer_write(buff,buffer_s16,1);
ev_add_local_inputs(AA,BB,CC,DD,ll,rr,uu,dd,LL1,LL2,RR1,RR2,sstart,ssel,buff);
buffer_write(buff,buffer_s16,0);
network_send_packet(sock_id,buff,buffer_tell(buff));

buffer_delete(buff);

#define network_Send_PlayerInput
/*
 * network_Send_PlayerINput();
 * Sends local player input across the network; current implementation was designed
 * to test whether the desyncs were caused by the way button_check_pressed was check-
 * ing against network inputs; problem remains. 
 */
var process = -1;
switch(argument0){
    case 0: process = button_check; break;
    case 1: process = button_check_pressed; break;
}
var processid = argument0;

var AA = script_execute(process,global.gamepad[global.ppos],global.pA[global.ppos]);
var BB = script_execute(process,global.gamepad[global.ppos],global.pB[global.ppos]);
var CC = script_execute(process,global.gamepad[global.ppos],global.pC[global.ppos]);
var DD = script_execute(process,global.gamepad[global.ppos],global.pD[global.ppos]);

var ll = script_execute(process,global.gamepad[global.ppos],global.pl[global.ppos]);
var rr = script_execute(process,global.gamepad[global.ppos],global.pr[global.ppos]);
var uu = script_execute(process,global.gamepad[global.ppos],global.pu[global.ppos]);
var dd = script_execute(process,global.gamepad[global.ppos],global.pd[global.ppos]);

var LL1 = script_execute(process,global.gamepad[global.ppos],global.pL1[global.ppos]);
var RR1 = script_execute(process,global.gamepad[global.ppos],global.pR1[global.ppos]);
var LL2 = script_execute(process,global.gamepad[global.ppos],global.pL2[global.ppos]);
var RR2 = script_execute(process,global.gamepad[global.ppos],global.pR2[global.ppos]);

var sstart = script_execute(process,global.gamepad[global.ppos],global.pstart[global.ppos]);
var ssel = script_execute(process,global.gamepad[global.ppos],global.pselect[global.ppos]);

var sock_id = -1;
if mode = "server"
    sock_id = global.opponent_sock;
else sock_id = global.client_socket;

var buff = buffer_create(16,buffer_grow,1);

buffer_write(buff,buffer_s16,1);
ev_add_local_inputs(AA,BB,CC,DD,ll,rr,uu,dd,LL1,LL2,RR1,RR2,sstart,ssel,buff);
buffer_write(buff,buffer_string,global.sync);
network_send_packet(sock_id,buff,buffer_tell(buff));

buffer_delete(buff);

#define network_Receive_Input
/*
 * network_Receive_Input();
 * Partially deprecated until a more consistent, less buggy
 * sycnronization method is created. Applies input that's received across
 * the network, and then, if in game, would tell the sender to resync if 
 * the games weren't synced. Because the inputs are sent during the begin
 * step event, the receiver always has the correct inputs, but the sender
 * has a desynced game state for a frame, likely because the sender receives
 * input from the receiver saying the sender hasn't pushed his button yet.
 * This sync method is currently removed as the synStat is never "DesyncERROR"
 */
var sock_id = -1;
if mode = "server"
    sock_id = global.opponent_sock;
else sock_id = global.client_socket;

for(i=0;i<14;i++){
    global.network_Input[i] = buffer_read(argument0,buffer_s8);
}

if room != roo_MainMenu{
    var synStat = buffer_read(argument0,buffer_string);
    if synStat = "DesyncERROR" && global.sync = "Synced"{
        var buff = buffer_create(16,buffer_grow,1);
    
        buffer_write(buff,buffer_s16,3);
        buffer_write(buff,buffer_string,ev_sgs_cb());
        network_send_packet(sock_id,buff,buffer_tell(buff));
        
        buffer_delete(buff);
    }
}

#define network_Update_InputState
/*
 * network_Update_InputState();
 * Sends ev_save_game_state() across the network so players can
 * confirm they have the same input for each frame. Currently 
 * players show a desynced frame whenever the input state changes for 
 * one frame, but the receiver is always synced. If both players are 
 * pressing buttons, both games will be desynced because both players
 * would be sending inputs and thus experiencing the desync. 
 */
var sock_id = -1;
if mode = "server"
    sock_id = global.opponent_sock;
else sock_id = global.client_socket;

var buff = buffer_create(16,buffer_grow,1);
                    
buffer_write(buff,buffer_s16,argument0);
buffer_write(buff,buffer_string,ev_save_game_state());
network_send_packet(sock_id,buff,buffer_tell(buff));

buffer_delete(buff);

#define network_GoodGame
/*
 * network_GoodGame();
 * Save game state to list & rollback if game desyncs
 */
 
ds_list_add(global.game_state,ev_sgs_cb());

if ds_list_size(global.game_state) > room_speed*3
    ds_list_delete(global.game_state,0);
 
ds_list_add(global.game_status,global.sync);

if ds_list_size(global.game_status) > room_speed*3
    ds_list_delete(global.game_status,0);

if global.sync = "Desync" {        
    while(ds_list_find_value(global.game_status,ds_list_size(global.game_status)-1) = "Desync") 
        && ds_list_size(global.game_status) > 0{
            ds_list_delete(global.game_status,ds_list_size(global.game_status)-1);
            ds_list_delete(global.game_state,ds_list_size(global.game_state)-1);
    }
    
    ev_lgs_cb(ds_list_find_value(global.game_state,ds_list_size(global.game_state)-1));
}

global.input_id = ds_list_size(global.input_confirm);

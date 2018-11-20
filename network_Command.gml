#define network_Command


#define network_Get_Latency
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
//network_Init_Sync();
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
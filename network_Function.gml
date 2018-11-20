#define network_Function


#define network_Create
global.gameplay_port = 11001;
global.latency = -1;
global.opponent_id = "";
global.ppos = choose(0,1);

var in_list = 0;

for(n=0;n<2;n++){
    for(i=0;i<14;i++){
        //Input for player to interpret;
        global.network_Input[i] = 0;
        global.network_Input_Pressed[i] = 0;
        global.network_Input_Last[i] = 0;
        
        //Input storage list for frame delay
        global.network_Input_ID[n,i] = in_list;
        global.network_Input_Store[0,in_list] = 0;
        in_list++;
    }
}
global.network_Input_State = 0;
global.frame_delay = 5;

global.online = true;

global.network_State = "runtime";
global.game_state = ds_list_create();
global.game_status = ds_list_create();
global.game_sum = ds_list_create();
global.input_confirm = ds_list_create();
global.input_id = 0;
global.checksum = "";
global.checksum_id = -1;
global.checksum_latency = 0;
global.game_state_id = 0;
global.sync = "Waiting";
global.net_sec = 0;
global.opponent_input = 0;

global.refresh[0] = 0; //input send delay
global.refresh[1] = 0; //input checksum delay

global.init_round = 0;

#define network_Setting
switch(mode){ 
    case "server":
        global.gameplay_server = network_create_server(server_type,global.gameplay_port,1);
        global.opponent_sock = -1;
        
    break;
    
    case "client":
        global.client_socket = network_create_socket(server_type);
        global.opponent_ip = "127.0.0.1";
        global.connection = network_connect(global.client_socket,global.opponent_ip,global.gameplay_port);
        while(global.connection <0)
            global.connection = network_connect(global.client_socket,global.opponent_ip,global.gameplay_port);
    break;
}

network_Get_Latency();
networkOn = true;

#define network_Server
var sock = ds_map_find_value(async_load,"socket");
var ip = ds_map_find_value(async_load,"ip");
var type = ds_map_find_value(async_load,"type");
var event_buff = -1;
var event_id = -1;
if type = network_type_data{
    event_buff = ds_map_find_value(async_load,"buffer");
    event_id = buffer_read(event_buff,buffer_s16);
}

var aPos = abs(global.ppos-1);

switch(type){
    case network_type_connect:
        global.opponent_sock = sock;
        
        if global.latency = -1
             network_Get_Latency();
        
        var buff = buffer_create(48,buffer_fixed,1);
        buffer_write(buff,buffer_s16,0);
        buffer_write(buff,buffer_string,username);
        buffer_write(buff,buffer_s16,global.ppos);
        
        network_send_packet(global.opponent_sock,buff,buffer_tell(buff));
        buffer_delete(buff);    
    break;
    
    case network_type_disconnect:
        global.opponent_sock = -1;
    break;
    
    case network_type_data:
        switch(event_id){
            case 0: //user info
                if room = roo_MainMenu{
                    global.opponent_id = buffer_read(event_buff,buffer_string);
                    ctrl_Menu.menu_set = 5;
                    global.mode = "Versus";
                }
            break;
            
            case 1://Receive input
                network_Receive_Input(event_buff);
                
                if room != roo_MainMenu{
                    //Send request to sync rounds
                    if !global.init_round{
                        var ibuff = buffer_create(16,buffer_fixed,1);
                        
                        buffer_write(ibuff,buffer_s16,2);
                        network_send_packet(global.opponent_sock,ibuff,buffer_tell(ibuff));
                        
                        buffer_delete(ibuff);
                    }
                }
            break;
            
            case 2:
                global.init_round = 1;
                network_Init_Sync();
                global.game_state_id++;
            break;
            
            case 3:
                ev_lgs_cb(buffer_read(event_buff,buffer_string));
                network_Update_InputState(11);
                ds_list_add(global.input_confirm,"rollback");
                //ds_list_set(global.input_confirm,buffer_read(event_buff,buffer_s16),"received");
            break;
            
            /*
             * Gamestate Controller
             */
             
            case 11:
                var syn = buffer_read(event_buff,buffer_string) == ev_save_game_state();
                if syn 
                    global.sync = "Synced"
                else {
                    global.sync = "Desync";
                    ds_list_add(global.input_confirm,"desync");
                }
                
                network_Update_InputState(11);
            break;
            
            case 12:
                var syn = buffer_read(event_buff,buffer_string) == ev_save_game_state();
                if syn 
                    global.sync = "Synced"
                else global.sync = "Desync";
            break;
            
            /*
             * Latency Configuration
             */
            
            case 1000: //latency_output
                var buff = buffer_create(48,buffer_grow,1);
                
                buffer_write(buff,buffer_s16,1001);
                buffer_write(buff,buffer_s32,buffer_read(event_buff,buffer_s32));
                network_send_packet(global.opponent_sock,buff,buffer_tell(buff));
                
                buffer_delete(buff);
            break;
            
            case 1001: //latency_set; latency_input
                global.latency = current_time - buffer_read(event_buff,buffer_s32);
                
                var buff = buffer_create(48,buffer_grow,1);
                
                buffer_write(buff,buffer_s16,1000);
                buffer_write(buff,buffer_s32,current_time);
                network_send_packet(global.opponent_sock,buff,buffer_tell(buff));
                
                buffer_delete(buff);
                
                global.refresh[0]++;
                if global.refresh[0] >= 2{/*
                    network_Send_PlayerInput(0);
                    network_Send_PlayerInput(1);
                    global.refresh[0] = 0;
                */}
            break;
        }
    break;
}

if type = network_type_data
    buffer_delete(event_buff);

#define network_Client
var type = ds_map_find_value(async_load,"type");
var event_buff = -1;
var event_id = -1;
if type = network_type_data{
    event_buff = ds_map_find_value(async_load,"buffer");
    event_id = buffer_read(event_buff,buffer_s16);
}

var aPos = abs(global.ppos-1);

switch(type){
    case network_type_data:
        switch(event_id){
            case 0: //user info
                if room = roo_MainMenu{
                    global.opponent_id = buffer_read(event_buff,buffer_text);
                    
                    var ppos_id = buffer_read(event_buff,buffer_s16);
                    if ppos_id = 0
                        global.ppos = 1;
                    else global.ppos = 0;
                    
                    var buff = buffer_create(32,buffer_fixed,1);
                    buffer_write(buff,buffer_s16,0);
                    buffer_write(buff,buffer_string,username);
                    
                    network_send_packet(global.client_socket,buff,buffer_tell(buff));
                    buffer_delete(buff);
                    
                    ctrl_Menu.menu_set = 5;
                    global.mode = "Versus";
                }
            break;
            
            case 1://Receive input
                network_Receive_Input(event_buff);
            break;
            
            case 2:
                //Confim can sync rounds
                var canGo = false;
                if instance_number(obj_PlayerParent) > 1
                    if instance_find(obj_PlayerParent,1).canPause
                        canGo = true;
                        
                if room != roo_MainMenu && canGo{
                    global.init_round = 1;
                
                    var ibuff = buffer_create(16,buffer_fixed,1);
                    
                    buffer_write(ibuff,buffer_s16,2);
                    network_send_packet(global.client_socket,ibuff,buffer_tell(ibuff));
                    
                    buffer_delete(ibuff);
                }
            break;
            
            case 3:
                ev_lgs_cb(buffer_read(event_buff,buffer_string));
                network_Update_InputState(11);
                ds_list_add(global.input_confirm,"rollback");
                //ds_list_set(global.input_confirm,buffer_read(event_buff,buffer_s16),"received");
            break;
            
            /*
             * Gamestate Controller
             */
            
            case 10:
                //sync rounds; begin input confirmation loop
                ev_lgs_cb(buffer_read(event_buff,buffer_string));
                global.game_state_id++;
                
                var buff = buffer_create(16,buffer_grow,1);
                
                buffer_write(buff,buffer_s16,11);
                buffer_write(buff,buffer_string,ev_save_game_state());
                network_send_packet(global.client_socket,buff,buffer_tell(buff));
                
                buffer_delete(buff);
            break;
            
            case 11:
                var syn = buffer_read(event_buff,buffer_string) == ev_save_game_state();
                if syn
                    global.sync = "Synced"
                else {
                    global.sync = "Desync";
                    ds_list_add(global.input_confirm,"desync");
                }
                
                network_Update_InputState(11);
            break;
            
            case 12:
                var syn = buffer_read(event_buff,buffer_string) == ev_save_game_state();
                if syn 
                    global.sync = "Synced"
                else global.sync = "Desync";
            break;
            
            /*
             * Latency Configuration
             */
            
            case 1000: //latency_output
                var buff = buffer_create(48,buffer_grow,1);
                
                buffer_write(buff,buffer_s16,1001);
                buffer_write(buff,buffer_s32,buffer_read(event_buff,buffer_s32));
                network_send_packet(global.client_socket,buff,buffer_tell(buff));
                
                buffer_delete(buff);
            break;
            
            case 1001: //latency_set; latency_input
                global.latency = current_time - buffer_read(event_buff,buffer_s32);
                
                var buff = buffer_create(48,buffer_grow,1);
                
                buffer_write(buff,buffer_s16,1000);
                buffer_write(buff,buffer_s32,current_time);
                network_send_packet(global.client_socket,buff,buffer_tell(buff));
                
                buffer_delete(buff);
                
                global.refresh[0]++;
                if global.refresh[0] >= 3{/*
                    network_Send_PlayerInput(0);
                    network_Send_PlayerInput(1);
                    global.refresh[0] = 0;
                */}
            break;
        }
    break;
}

buffer_delete(event_buff);

#define network_Destroy
switch(mode){ 
    case "server":
        network_destroy(global.gameplay_server);
        global.opponent_sock = -1;
    break;
    
    case "client":
        network_destroy(global.client_socket);
    break;
}
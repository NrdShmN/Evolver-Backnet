#define Evolver_BackNet


#define ev_save_game_state
var chksum = "";

for(i=0;i<2;i++){
    chksum += string(button_check(global.gamepad[i],global.pl[i]));
    chksum += string(button_check(global.gamepad[i],global.pr[i]));
    chksum += string(button_check(global.gamepad[i],global.pu[i]));
    chksum += string(button_check(global.gamepad[i],global.pd[i]));

    chksum += string(button_check(global.gamepad[i],global.pA[i]));
    chksum += string(button_check(global.gamepad[i],global.pB[i]));
    chksum += string(button_check(global.gamepad[i],global.pC[i]));
    chksum += string(button_check(global.gamepad[i],global.pD[i]));
    
    chksum += string(button_check(global.gamepad[i],global.pL1[i]));
    chksum += string(button_check(global.gamepad[i],global.pL2[i]));
    chksum += string(button_check(global.gamepad[i],global.pR1[i]));
    chksum += string(button_check(global.gamepad[i],global.pR2[i]));
    
    chksum += string(button_check(global.gamepad[i],global.pstart[i]));
    chksum += string(button_check(global.gamepad[i],global.pselect[i]));
}

return base64_encode(chksum);

#define ev_load_game_state


#define ev_sgs_cb
/*
 * ev_sgs_cb
 */
var pstates = ds_map_create();

for (i=0;i<instance_number(obj_PlayerParent);i++){
    if instance_exists(instance_find(obj_PlayerParent,i))
        p = instance_find(obj_PlayerParent,i)
    else {
        p = noone; 
        exit;
    }
    
    ds_map_add(pstates,"x" + string(i),p.x);
    ds_map_add(pstates,"y" + string(i),p.y);
    ds_map_add(pstates,"xVel" + string(i),p.xVel);
    ds_map_add(pstates,"yVel" + string(i),p.yVel);
    ds_map_add(pstates,"hVel" + string(i),p.hVel);
    ds_map_add(pstates,"vVel" + string(i),p.vVel);
    ds_map_add(pstates,"sprite_index" + string(i),p.sprite_index);
    ds_map_add(pstates,"image_index" + string(i),p.image_index);
    
    ds_map_add(pstates,"meter" + string(i),p.meter);
    ds_map_add(pstates,"breakerCounter" + string(i),p.breakerCounter);
    ds_map_add(pstates,"vuln" + string(i),p.vuln);
    ds_map_add(pstates,"attacking" + string(i),p.attacking);
    ds_map_add(pstates,"running" + string(i),p.running);
    ds_map_add(pstates,"machine" + string(i),p.machine);
    ds_map_add(pstates,"dodging" + string(i),p.dodging);
    ds_map_add(pstates,"parrying" + string(i),p.parrying);
    ds_map_add(pstates,"trueParry" + string(i),p.trueParry);
    ds_map_add(pstates,"parried" + string(i),p.parried);
    ds_map_add(pstates,"taunting" + string(i),p.taunting);
    ds_map_add(pstates,"blasting" + string(i),p.blasting);
    ds_map_add(pstates,"crashLanding" + string(i),p.crashLanding);
    ds_map_add(pstates,"miscAction" + string(i),p.miscAction);
    ds_map_add(pstates,"nearAction" + string(i),p.nearAction);
    ds_map_add(pstates,"down_check" + string(i),p.down_check);
    ds_map_add(pstates,"Action" + string(i),p.Action);
    ds_map_add(pstates,"onGround" + string(i),p.onGround);
    ds_map_add(pstates,"onGhost" + string(i),p.onGhost);
    ds_map_add(pstates,"onWall" + string(i),p.onWall);
    ds_map_add(pstates,"onWallTimer" + string(i),p.onWallTimer);
    ds_map_add(pstates,"powerForce" + string(i),p.powerForce);
    ds_map_add(pstates,"superMove" + string(i),p.superMove);
    ds_map_add(pstates,"reset" + string(i),p.reset);
    ds_map_add(pstates,"controlBurst" + string(i),p.controlBurst);
    ds_map_add(pstates,"augmentBurst" + string(i),p.augmentBurst);
    ds_map_add(pstates,"powerBurst" + string(i),p.powerBurst);
    ds_map_add(pstates,"soulBurst" + string(i),p.soulBurst);
    ds_map_add(pstates,"spawnTimer" + string(i),p.spawnTimer);
    ds_map_add(pstates,"comboCounter" + string(i),p.comboCounter);
    ds_map_add(pstates,"damageCount" + string(i),p.damageCount);
    ds_map_add(pstates,"scoreCounter" + string(i),p.scoreCounter);
    ds_map_add(pstates,"killStreak" + string(i),p.killStreak);
    ds_map_add(pstates,"hitCounter" + string(i),p.hitCounter);
    ds_map_add(pstates,"meterAdd" + string(i),p.meterAdd);
    ds_map_add(pstates,"meterRate" + string(i),p.meterRate);
    ds_map_add(pstates,"throwForce" + string(i),p.throwForce);
    ds_map_add(pstates,"finFrame" + string(i),p.finFrame);
    ds_map_add(pstates,"sprite_next" + string(i),p.sprite_next);
    ds_map_add(pstates,"sprite_current" + string(i),p.sprite_current);
    ds_map_add(pstates,"style_num" + string(i),p.style_num);
    ds_map_add(pstates,"style_next" + string(i),p.style_next);
    ds_map_add(pstates,"style_current" + string(i),p.style_current);
    ds_map_add(pstates,"style_max" + string(i),p.style_max);
    ds_map_add(pstates,"com_num" + string(i),p.com_num);
    ds_map_add(pstates,"spec_num" + string(i),p.spec_num);
    ds_map_add(pstates,"super_num" + string(i),p.super_num);
    ds_map_add(pstates,"atkKey" + string(i),p.atkKey);
    ds_map_add(pstates,"lastAtk" + string(i),p.lastAtk);
    ds_map_add(pstates,"last_button" + string(i),p.last_button);
    ds_map_add(pstates,"throw_dist" + string(i),p.throw_dist);
    ds_map_add(pstates,"throw_air" + string(i),p.throw_air);
    ds_map_add(pstates,"jumpAttack_count" + string(i),p.jumpAttack_count);
    ds_map_add(pstates,"jumpAttack_charge" + string(i),p.jumpAttack_charge);
    ds_map_add(pstates,"jumpAttack_store" + string(i),p.jumpAttack_store);
    ds_map_add(pstates,"vitality" + string(i),p.vitality);
    ds_map_add(pstates,"vitloss" + string(i),p.vitloss);
    ds_map_add(pstates,"armor" + string(i),p.armor);
    ds_map_add(pstates,"beingHit" + string(i),p.beingHit);
    ds_map_add(pstates,"thrown" + string(i),p.thrown);
    ds_map_add(pstates,"killed" + string(i),p.killed);
    ds_map_add(pstates,"finished" + string(i),p.finished);
    ds_map_add(pstates,"exceed" + string(i),p.exceed);
    ds_map_add(pstates,"augmented" + string(i),p.augmented);
    ds_map_add(pstates,"hitStun" + string(i),p.hitStun);
    ds_map_add(pstates,"hitStunned" + string(i),p.hitStunned);
    ds_map_add(pstates,"hitRecovery_stun" + string(i),p.hitRecovery_stun);
    ds_map_add(pstates,"downStun" + string(i),p.downStun);
    ds_map_add(pstates,"gFactor" + string(i),p.gFactor);
    ds_map_add(pstates,"groundBounced" + string(i),p.groundBounced);
    ds_map_add(pstates,"breakerEarned" + string(i),p.breakerEarned);
    ds_map_add(pstates,"hardKnock" + string(i),p.hardKnock);
    ds_map_add(pstates,"overattacked" + string(i),p.overattacked);
}

for(i=0;i<instance_number(obj_Hitbox);i++;){
    
}

var _json = json_encode(pstates);
ds_map_destroy(pstates);
return _json;

#define ev_lgs_cb
/*
 * ev_lgs_cb
 */
var pstates = json_decode(argument0);
if pstates < 0
    exit;
        
for(i=0;i<instance_number(obj_PlayerParent);i++){

    if instance_exists(instance_find(obj_PlayerParent,i))
        p = instance_find(obj_PlayerParent,i)
    else {
        p = noone; 
        exit;
    }
    
    var _x = ds_map_find_value(pstates,"x" + string(i));
    var _y = ds_map_find_value(pstates,"y" + string(i));
    var _xVel = ds_map_find_value(pstates,"xVel" + string(i));
    var _yVel = ds_map_find_value(pstates,"yVel" + string(i));
    var _hVel = ds_map_find_value(pstates,"hVel" + string(i));
    var _vVel = ds_map_find_value(pstates,"vVel" + string(i));
    var _sprite_index = ds_map_find_value(pstates,"sprite_index" + string(i));
    var _image_index = ds_map_find_value(pstates,"image_index" + string(i));
    
    var _meter = ds_map_find_value(pstates,"meter" + string(i));
    var _breakerCounter = ds_map_find_value(pstates,"breakerCounter" + string(i));
    var _vuln = ds_map_find_value(pstates,"vuln" + string(i));
    var _attacking = ds_map_find_value(pstates,"attacking" + string(i));
    var _running = ds_map_find_value(pstates,"running" + string(i));
    var _machine = ds_map_find_value(pstates,"machine" + string(i));
    var _dodging  = ds_map_find_value(pstates,"dodging" + string(i));
    var _parrying = ds_map_find_value(pstates,"parrying" + string(i));
    var _trueParry = ds_map_find_value(pstates,"trueParry" + string(i));
    var _parried = ds_map_find_value(pstates,"parried" + string(i));
    var _taunting = ds_map_find_value(pstates,"taunting" + string(i));
    var _blasting = ds_map_find_value(pstates,"blasting" + string(i));
    var _crashLanding = ds_map_find_value(pstates,"crashLanding" + string(i));
    var _miscAction = ds_map_find_value(pstates,"miscAction" + string(i));
    var _nearAction = ds_map_find_value(pstates,"nearAction" + string(i));
    var _down_check = ds_map_find_value(pstates,"down_check" + string(i));
    var _Action = ds_map_find_value(pstates,"Action" + string(i));
    var _onGround = ds_map_find_value(pstates,"onGround" + string(i));
    var _onGhost = ds_map_find_value(pstates,"onGhost" + string(i));
    var _onWall = ds_map_find_value(pstates,"onWall" + string(i));
    var _onWallTimer = ds_map_find_value(pstates,"onWallTimer" + string(i));
    var _powerForce= ds_map_find_value(pstates,"powerForce" + string(i));
    var _superMove = ds_map_find_value(pstates,"superMove" + string(i));
    var _reset = ds_map_find_value(pstates,"reset" + string(i));
    var _controlBurst = ds_map_find_value(pstates,"controlBurst" + string(i));
    var _augmentBurst = ds_map_find_value(pstates,"augmentBurst" + string(i));
    var _powerBurst = ds_map_find_value(pstates,"powerBurst" + string(i));
    var _soulBurst = ds_map_find_value(pstates,"soulBurst" + string(i));
    var _spawnTimer = ds_map_find_value(pstates,"spawnTimer" + string(i));
    var _comboCounter = ds_map_find_value(pstates,"comboCounter" + string(i));
    var _damageCount = ds_map_find_value(pstates,"damageCount" + string(i));
    var _scoreCounter = ds_map_find_value(pstates,"scoreCounter" + string(i));
    var _killStreak = ds_map_find_value(pstates,"killStreak" + string(i));
    var _hitCounter = ds_map_find_value(pstates,"hitCounter" + string(i));
    var _meterAdd = ds_map_find_value(pstates,"meterAdd" + string(i));
    var _meterRate = ds_map_find_value(pstates,"meterRate" + string(i));
    var _throwForce = ds_map_find_value(pstates,"throwForce" + string(i));
    var _finFrame = ds_map_find_value(pstates,"finFrame" + string(i));
    var _sprite_next = ds_map_find_value(pstates,"sprite_next" + string(i));
    var _sprite_current = ds_map_find_value(pstates,"sprite_current" + string(i));
    var _style_num = ds_map_find_value(pstates,"style_num" + string(i));
    var _style_next = ds_map_find_value(pstates,"style_next" + string(i));
    var _style_current = ds_map_find_value(pstates,"style_current" + string(i));
    var _style_max = ds_map_find_value(pstates,"style_max" + string(i));
    var _com_num = ds_map_find_value(pstates,"com_num" + string(i));
    var _spec_num = ds_map_find_value(pstates,"spec_num" + string(i));
    var _super_num = ds_map_find_value(pstates,"super_num" + string(i));
    var _atkKey = ds_map_find_value(pstates,"atkKey" + string(i));
    var _lastAtk = ds_map_find_value(pstates,"lastAtk" + string(i));
    var _last_button = ds_map_find_value(pstates,"last_button" + string(i));
    var _throw_dist = ds_map_find_value(pstates,"throw_dist" + string(i));
    var _throw_air = ds_map_find_value(pstates,"throw_air" + string(i));
    var _jumpAttack_count = ds_map_find_value(pstates,"jumpAttack_count" + string(i));
    var _jumpAttack_charge = ds_map_find_value(pstates,"jumpAttack_charge" + string(i));
    var _jumpAttack_store = ds_map_find_value(pstates,"jumpAttack_store" + string(i));
    var _vitality = ds_map_find_value(pstates,"vitality" + string(i));
    var _vitloss = ds_map_find_value(pstates,"vitloss" + string(i));
    var _armor = ds_map_find_value(pstates,"armor" + string(i));
    var _beingHit = ds_map_find_value(pstates,"beingHit" + string(i));
    var _thrown = ds_map_find_value(pstates,"thrown" + string(i));
    var _killed = ds_map_find_value(pstates,"killed" + string(i));
    var _finished = ds_map_find_value(pstates,"finished" + string(i));
    var _exceed = ds_map_find_value(pstates,"exceed" + string(i));
    var _augmented = ds_map_find_value(pstates,"augmented" + string(i));
    var _hitStun = ds_map_find_value(pstates,"hitStun" + string(i));
    var _hitStunned = ds_map_find_value(pstates,"hitStunned" + string(i));
    var _hitRecovery_stun = ds_map_find_value(pstates,"hitRecovery_stun" + string(i));
    var _downStun = ds_map_find_value(pstates,"downStun" + string(i));
    var _gFactor = ds_map_find_value(pstates,"gFactor" + string(i));
    var _groundBounced = ds_map_find_value(pstates,"groundBounced" + string(i));
    var _breakerEarned = ds_map_find_value(pstates,"breakerEarned" + string(i));
    var _hardKnock = ds_map_find_value(pstates,"hardKnock" + string(i));
    var _overattacked = ds_map_find_value(pstates,"overattacked" + string(i));
    
    with(p){
        x = _x;
        y = _y;
        xVel = _xVel;
        yVel = _yVel;
        hVel = hVel;
        vVel = vVel;
        sprite_index = _sprite_index;
        image_index = _image_index;
        
        meter = _meter;
        breakerCounter = _breakerCounter;
        vuln = _vuln;
        attacking = _attacking;
        running = _running;
        machine = _machine;
        dodging = _dodging;
        parrying = _parrying;
        trueParry = _trueParry;
        parried  = _parried;
        taunting  = _taunting;
        blasting  = _blasting;
        crashLanding  = _crashLanding;
        miscAction  = _miscAction;
        nearAction  = _nearAction;
        down_check  = _down_check;
        Action = _Action;
        onGround = _onGround;
        onGhost  = _onGhost;
        onWall  = _onWall;
        onWallTimer = _onWallTimer;
        powerForce = _powerForce;
        superMove = _superMove;
        reset = _reset;
        controlBurst = _controlBurst;
        augmentBurst = _augmentBurst;
        powerBurst = _powerBurst;
        soulBurst = _soulBurst;
        spawnTimer = _spawnTimer;
        comboCounter = _comboCounter;
        damageCount = _damageCount;
        killStreak = _killStreak;
        hitCounter = _hitCounter;
        meterAdd = _meterAdd;
        meterRate = _meterRate;
        throwForce = _throwForce;
        finFrame = _finFrame;
        sprite_next = _sprite_next;
        sprite_current = _sprite_current;
        style_num = _style_num;
        style_next = _style_next;
        style_current = _style_current;
        style_max = _style_max;
        com_num = _com_num;
        spec_num = _spec_num;
        super_num = _super_num;
        atkKey = _atkKey;
        lastAtk = _lastAtk;
        last_button = _last_button;
        throw_dist = _throw_dist;
        throw_air = _throw_air;
        jumpAttack_count = _jumpAttack_count;
        jumpAttack_charge = _jumpAttack_charge;
        jumpAttack_store = _jumpAttack_store;
        vitality = _vitality;
        vitloss = _vitloss;
        armor = _armor;
        beingHit = _beingHit;
        thrown = _thrown;
        killed = _killed;
        finished = _finished;
        exceed = _exceed;
        augmented = _augmented;
        hitStun = _hitStun;
        hitStunned = _hitStunned;
        hitRecovery_stun = _hitRecovery_stun;
        downStun = _downStun;
        gFactor = _gFactor;
        groundBounced = _groundBounced;
        breakerEarned = _breakerEarned;
        hardKnock = _hardKnock;
        overattacked = _overattacked;
    } 
}

ds_map_destroy(pstates);

#define ev_add_local_inputs
//ev_add_local_inputs(A,B,C,D,u,d,l,r,L1,L2,R1,R2,start,select,socket);

input[0] = argument0;
input[1] = argument1;
input[2] = argument2;
input[3] = argument3;
input[4] = argument4;
input[5] = argument5;
input[6] = argument6;
input[7] = argument7;
input[8] = argument8;
input[9] = argument9;
input[10] = argument10;
input[11] = argument11;
input[12] = argument12;
input[13] = argument13;

var inputs = argument14;

for(i=0;i<14;i++){
    buffer_write(inputs,buffer_s8,input[i]);
}



#define ev_add_network_inputs
var aPos = abs(global.ppos-1);
        
for(i=0;i<14;i++){
    if object_index = ctrl_Menu
        numSto[i] = global.network_Input[i];
    else numSto[i] = i;
}

global.pA[aPos] = numSto[0];
global.pB[aPos] = numSto[1];
global.pC[aPos] = numSto[2];
global.pD[aPos] = numSto[3];

global.pl[aPos] = numSto[4];
global.pr[aPos] = numSto[5];
global.pu[aPos] = numSto[6];
global.pd[aPos] = numSto[7];

global.pforward[aPos] = global.pr[aPos];

global.pL1[aPos] = numSto[8];
global.pL2[aPos] = numSto[9];
global.pR1[aPos] = numSto[10];
global.pR2[aPos] = numSto[11];

global.pstart[aPos] = numSto[12];
global.pselect[aPos] = numSto[13];
global.pL3[aPos] = false;
global.pR3[aPos] = false;

if object_index = ctrl_Menu
    global.gamepad[aPos] = 1001;
else global.gamepad[aPos] = 1000;
#define ev_add_local_inputs_pressed

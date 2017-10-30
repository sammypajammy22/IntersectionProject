;Sam Reles
Assume cs:code, ds:data, ss:stack
data segment
Pushbutton db 0              ;The variable for the pushbutton for the pedestrian
Northbutton db 0            ;The variable for the north sensor
Southbutton db 0            ;south sensor variable
mainMenuMessage db " Please type 1 for daymode or 2 for nightmode $"      ;main menu
; All variables defined within the data segment
data ends
stack segment
dw 100 dup(?)
;Stack size and the top of the stack defined in the stack segment
stacktop:
stack ends

code segment

begin:	                      ;beginning of the code segment
mov ax, data
mov ds,ax
mov ax, stack
mov ss,ax
mov sp, offset stacktop
;PORT A
MOV DX,143H                     ;Set to direction mode
MOV AL,02H
OUT DX,AL

MOV DX,140H                    ;Set up input/output
MOV AL,00111111b
OUT DX,AL

MOV DX,143H                ;Set into operation mode
MOV AL,03H
OUT DX,AL

;PORT B
MOV DX,143H             ;Set up direction mode
MOV AL,02H
OUT DX,AL

MOV DX,141H                  ;Set up input/output
MOV AL,11011111b
OUT DX,AL

MOV DX,143H                ;Set into operation mode
MOV AL,03H
OUT DX,AL

;PORT C
MOV DX,143H         ;Set up direction mode
MOV AL,02H
OUT DX,AL

MOV DX,142H       ;Set up input/output
MOV AL,00011111b
OUT DX,AL

MOV DX,143H             ;Set into operation mode
MOV AL,03H
OUT DX,AL

mainMenu:                             ;the main menu for the user
mov si, offset mainMenuMessage           ;displays main menu message
;call print
startup:
call print                ;print main menu
MOV AH, 01H       ;allows for the user to input a selection without it appearing on the window
INT 21H
    ;here is where the four input commands from the user can be accessed
CMP AL, '1'
JE Daymode        ;move to daymode if 1
CMP AL, '2'
JE Nightmode          ;move to nightmode if 2

JMP mainMenu       ;go back to mainmenu



Daymode:            ;code for daymode
Call North           ;sets up north lights
Call South           ;sets up south lights
Call EWLeft           ;sets up turn lanes
Call EastWest      ;sets up east-west traffic lanes


mov si, offset Pushbutton   ;move pushbutton to si
mov dl, 1         ;move 1 to dl
cmp dl, [si]  ;compare
jne Daymode   ;if not 1 go to daymode again

;cmp Pushbutton, 1

call debugging       ;will cause a 7 to appear on the computer screen, proving the sensor works
call Pedestrian     ;code for pedestrian lights
mov Pushbutton, 0        ;reset pushbutton

jmp Daymode


debugging:              ;debugging code, presents a 7 on the output screen
push ax
push dx
mov ah, 02h
mov dl, "7"
int 21h
pop dx
pop ax
ret


North:               ;Code to define north LED signals
PUSH DX
PUSH AX ;Moves the North light from Green to Red
MOV DX, 140H
AND AL, 00100001b      ;Green light on North
MOV AL, 00100001b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10000100b
MOV AL, 10000100b ;The East light are on Red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100010b      ;Yellow light on North
MOV AL, 00100010b      ;Red light on South
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL
Call Delay
POP AX
POP DX
RET

South:                   ;Code for south light signals
PUSH DX
PUSH AX     ;Turns the South light from Green to Red
MOV DX, 140H
AND AL, 00001100b      ;Red light on North
MOV AL, 00001100b      ;Green light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10000100b
MOV AL, 10000100b ;The East light are on Red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00010100b      ;Red light on North
MOV AL, 00010100b      ;Yellow light on South
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL
Call Delay
POP AX
POP DX
RET

EWLeft:                  ;code for turn signals
PUSH DX
PUSH AX
MOV DX, 140H
AND AL, 00100100b      ;Green light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10010100b
MOV AL, 10010100b ;the East light are on Red, but the east turn is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10001100b
MOV AL, 10001100b ;the East light are on Red,
OUT DX, AL        ;East turn is yellow
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10000100b
MOV AL, 10000100b ;the East light are on Red,
OUT DX, AL        ;East turn is off
Call Delay

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00010100b ;west turn is on green
MOV AL, 00010100b
OUT DX, AL
Call Delay

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00001100b ;west turn is on yellow
MOV AL, 00001100b
OUT DX, AL
Call Delay

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000100b ;west turn is off
MOV AL, 00000100b
OUT DX, AL
Call Delay
POP AX
POP DX
RET

EastWest:              ;Code for east-west traffic
PUSH DX
PUSH AX
MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000001b
MOV AL, 10000001b ;the East light is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000010b
MOV AL, 10000010b ;the East light is on yellow
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on yellow
AND AL, 00000010b
MOV AL, 00000010b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10000100b
MOV AL, 10000100b ;the East light are on red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay
POP AX
POP DX
RET






;;;;;;;cut to nightmode








Nightmode:                  ;code used if user selects 2
call Default                  ;the generic “East-West” traffic code
call Checkbuttons        ;check the Ped-North-South sensors


;compare pedflag
cmp Pushbutton, 1         ;check pushbutton
jne s
call debugging
call PedestrianN       ;send to pedestrian loop
mov Pushbutton, 0       ;reset pushbutton

;compare southflag
s:
cmp Southbutton, 1      ;compare south sensor
jne n
call debugging
call Southnight                ;send to south light loop
mov Southbutton, 0       ;reset


;compare northflag
n:
cmp Northbutton, 1            ;compare north sensor
jne Nightmode
call debugging
call Northnight                   ;send to north light loop
mov Northbutton, 0           ;reset

jmp Nightmode



;Call EastWestnight       ;constant east-west traffic

;pedestrian
mov si, offset Pushbutton         ;pedestrian check
mov dl, 1
cmp dl, [si]
jne Nightmode


call debugging     ;send a seven
call PedestrianN         ;pedestrian loop
mov Pushbutton, 0   ;reset

jmp Nightmode

;north turn
mov si, offset Northbutton        ;checks north turn
mov dl, 1
cmp dl, [si]
jne Nightmode


call debugging       ;produce a seven
call Northnight         ;north loop
mov Northbutton, 0         ;reset

jmp Nightmode

;south turn
mov si, offset Southbutton        ;check south sensor
mov dl, 1
cmp dl, [si]
jne Nightmode


call debugging        ;produce a seven
call Southnight           ;south code
mov Southbutton, 0         ;reset

jmp Nightmode


Default:           ;sets up all values as the original aka East-West code traffic lights are back on
push ax
push dx
mov dx, 140h
mov al, 00100100b
out dx, al

mov dx, 141h
mov al, 10000001b
out dx, al

mov dx, 142h
mov al, 00000001b
out dx, al
pop dx
pop ax
ret

EastWestnight:
PUSH DX
PUSH AX
MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000001b
MOV AL, 10000001b ;the East light is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000001b
MOV AL, 10000001b ;the East light is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000001b
MOV AL, 10000001b ;the East light is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay

POP AX
POP DX
RET


Northnight:
PUSH DX
PUSH AX
MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000001b
MOV AL, 10000001b ;the East light is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay
MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000010b
MOV AL, 10000010b ;the East light is yellow
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is yellow
AND AL, 00000010b
MOV AL, 00000010b
OUT DX, AL
Call Delay
MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000100b
MOV AL, 10000100b ;the East light is red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00001100b      ;Red light on North
MOV AL, 00001100b      ;Green light on South
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00010100b      ;Red light on North
MOV AL, 00010100b      ;Green light on South
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Green light on South
OUT DX, AL
Call Delay
POP AX
POP DX
RET

Southnight:
PUSH DX
PUSH AX
MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000001b
MOV AL, 10000001b ;the East light is on
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000010b
MOV AL, 10000010b ;the East light is red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000010b
MOV AL, 00000010b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light off
AND AL, 10000100b
MOV AL, 10000100b ;the East light is red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100001b      ;Green light on North
MOV AL, 00100001b      ;Red light on South
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100010b      ;Yellow light on North
MOV AL, 00100010b      ;Red light on South
OUT DX, AL
Call Delay

MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL
Call Delay
POP AX
POP DX
RET





;;;;;;;;;;cut to other parts of code








Pedestrian:
push DX
push AX
MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light green
AND AL, 01000100b
MOV AL, 01000100b ;the East light are on red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light and
AND AL, 10000100b
MOV AL, 10000100b ;the East light are on red
OUT DX, AL
Call Delay
POP AX
POP DX
RET

PedestrianN:
push DX
push AX
MOV DX, 140H
AND AL, 00100100b      ;Red light on North
MOV AL, 00100100b      ;Red light on South
OUT DX, AL

MOV DX, 141H      ;Signals that the Pedestrian light green
AND AL, 10000001b
MOV AL, 10000001b ;the East light are on red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on red
AND AL, 00000001b
MOV AL, 00000001b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light green
AND AL, 10000010b
MOV AL, 10000010b ;the East light are on red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on red
AND AL, 00000010b
MOV AL, 00000010b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light green
AND AL, 10000100b
MOV AL, 10000100b ;the East light are on red
OUT DX, AL

MOV DX, 142H      ;Signals that the West Light is on red
AND AL, 00000100b
MOV AL, 00000100b
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light red
AND AL, 01000100b
MOV AL, 01000100b ;the East light are on red
OUT DX, AL
Call Delay

MOV DX, 141H      ;Signals that the Pedestrian light green
AND AL, 10000100b
MOV AL, 10000100b ;the East light are on red
OUT DX, AL
Call Delay
POP AX
POP DX
RET

Checkbuttons:
push ax
push bx
push cx
push dx


mov dx, 142h
; MOV AL,Pushbutton              ;set pushbutton variable to 1
IN al, dx
AND AL, 01000000b
CMP AL, 00000000b
JNE next

mov Pushbutton, 1
call debugging
jmp breakout

next:                    ;set variable of north to 1
mov dx, 140h
; MOV AL,Pushbutton
IN al, dx
AND AL, 11000000b
CMP AL, 10000000b
JNE last

mov Northbutton, 1
call debugging
JMP breakout

last:                              ;set variable for south to 1
mov dx, 140h
; MOV AL,Pushbutton
IN al, dx
AND AL, 11000000b
CMP AL, 01000000b
JNE breakout

mov Southbutton, 1
call debugging


breakout:                 ;breakout of the loop
pop dx
pop cx
pop bx
pop ax
ret



Delay:                       ;delays the output
push AX
push BX
push CX
push DX

mov dx, 142h
; MOV AL,Pushbutton
IN al, dx
AND AL, 01000000b
CMP AL, 00000000b
JNE Nextcheck

mov Pushbutton, 1
call debugging

Nextcheck:
mov dx, 140h
; MOV AL,Pushbutton
IN al, dx
AND AL, 11000000b
CMP AL, 10000000b
JNE Lastcheck

mov Northbutton, 1
call debugging
JMP Donoting

Lastcheck:
mov dx, 140h
; MOV AL,Pushbutton
IN al, dx
AND AL, 11000000b
CMP AL, 01000000b
JNE Donoting

mov Southbutton, 1
call debugging

Donoting:
mov cx, 7
bleh:
mov bx, 0FFFFh
mov bp, 0Ah
loopy:     ;The loop continues to run until both CX and BX equal 0
nop      ;Then the loop will move back to the display code sequence
dec bx
cmp bx, 0
jne loopy
mov bx, 0FFFFh
dec bp
cmp bp, 0
jne loopy
loop bleh

pop DX
pop CX
pop BX
pop AX
ret

print:                  ;The subroutine used to print data onto the screen
push ax
push dx

mov ah, 2

stuff1:
mov dl, [si]
cmp dl, "$"
je endOfString

int 21h
inc si
jmp stuff1

endOfString:
pop dx
pop ax
ret


code ends
end begin

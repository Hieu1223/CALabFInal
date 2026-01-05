.eqv IN_ADDRESS_HEXA_KEYBOARD  0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014

.data
message: .asciz "Key scan code: "

.text


# --------------------------------------------------
# get_key_xy
#   stores column -> key_x
#   stores row    -> key_y
# --------------------------------------------------
get_key:
    # ---------- scan keypad ----------
    li t6, 0                      # t6 = accumulated keycode

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x01
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x02
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x04
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x88
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add t6, t6, t0


translate_key_code:
    andi t0, t6, 0xff              
    li t1 0
    li t3 1
    andi t4 t0 0xf
    input_row_loop_start:
    beq t4 t3 input_row_loop_end
    srli t4 t4 1
    addi t1 t1 1
    j input_row_loop_start
    input_row_loop_end:
    
    la t5 key_y
    sw t1 0(t5)
    # do col
    li t1 0
    srli t0 t0 4 # mask the correct ones
    input_col_loop_start:
    beq t0 t3 input_col_loop_end
    srli t0 t0 1
    addi t1 t1 1
    j input_col_loop_start
    input_col_loop_end:
    
    
    la t5 key_x
    sw t1 0(t5)

    ret

 

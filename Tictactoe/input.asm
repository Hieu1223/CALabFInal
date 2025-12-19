.eqv IN_ADDRESS_HEXA_KEYBOARD  0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014

.data
message: .asciz "Key scan code: "

.text

get_key_code:
    li a0, 0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x01              # Check row 1
    sb t2, 0(t1)             # Must reassign expected row
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add a0, a0, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x02              # Check row 2
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add a0, a0, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x04              # Check row 3
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add a0, a0, t0

    li t1, IN_ADDRESS_HEXA_KEYBOARD
    li t2, 0x88              # Check row 4 and re-enable bit 7
    sb t2, 0(t1)
    li t1, OUT_ADDRESS_HEXA_KEYBOARD
    lb t0, 0(t1)
    add a0, a0, t0
    andi a0 a0 0xff
    ret

ebreak


# a0 = keycode (0xFF masked)
translate_key_code:
    mv   t6, a0            # save keycode

    # ---------- decode column (x) ----------
    andi t0, t6, 0x0F      # column bits
    li   t1, 0             # x = 0

col_loop:
    andi t2, t0, 1
    bnez t2, col_done
    srli t0, t0, 1
    addi t1, t1, 1
    j col_loop

col_done:
    la   t3, key_y
    sw   t1, 0(t3)

    # ---------- decode row (y) ----------
    andi t0, t6, 0xF0      # row bits
    srli t0, t0, 4
    li   t1, 0             # y = 0

row_loop:
    andi t2, t0, 1
    bnez t2, row_done
    srli t0, t0, 1
    addi t1, t1, 1
    j row_loop

row_done:
    la   t3, key_x
    sw   t1, 0(t3)

    ret
ebreak
 

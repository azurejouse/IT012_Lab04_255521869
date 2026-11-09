# IT012_Lab04_<MSSV>_MR.asm - dem thang theo bac + tinh tong tien (nhan bang cong lap)
.data
m1:      .asciiz "Thang "
m2:      .asciiz ": "
mb:      .asciiz "Bac "
mt:      .asciiz "Tong tien: "
nl:      .asciiz "\n"
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995
usage:   .space 48
cnt:     .word 0, 0, 0, 0
price:   .word 1000, 1500, 2000, 2500   # don gia bac 1..4 (GIA DINH, doi theo Bang 6)

.text
.globl main
main:
  la   $s0, reading
  la   $s1, usage
  la   $s4, cnt
  addi $s2, $zero, 0    # i = 0
  addi $s3, $zero, 12   # n = 12

# ---- Phan 1: tinh usage[i] va in tung thang ----
Loop:
  beq  $s2, $s3, Phase2
  sll  $t0, $s2, 2
  add  $t1, $t0, $s0
  lw   $t3, 0($t1)
  lw   $t4, 4($t1)
  sub  $t5, $t4, $t3
  add  $t2, $t0, $s1
  sw   $t5, 0($t2)

  li   $v0, 4
  la   $a0, m1
  syscall
  li   $v0, 1
  addi $a0, $s2, 1
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  li   $v0, 1
  add  $a0, $t5, $zero
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  addi $s2, $s2, 1
  j    Loop

# ---- Phan 2: xac dinh bac, tang cnt, tinh tien ----
Phase2:
  addi $s2, $zero, 0    # i = 0
  addi $s6, $zero, 0    # tong tien = 0
Loop2:
  beq  $s2, $s3, Print
  sll  $t0, $s2, 2
  add  $t1, $t0, $s1
  lw   $t5, 0($t1)      # $t5 = usage[i]

  slti $t6, $t5, 101
  bne  $t6, $zero, B1
  slti $t6, $t5, 151
  bne  $t6, $zero, B2
  slti $t6, $t5, 201
  bne  $t6, $zero, B3
  addi $t7, $zero, 3
  j    Tang
B1:
  addi $t7, $zero, 0
  j    Tang
B2:
  addi $t7, $zero, 1
  j    Tang
B3:
  addi $t7, $zero, 2
Tang:
  sll  $t8, $t7, 2
  add  $t8, $t8, $s4
  lw   $t9, 0($t8)
  addi $t9, $t9, 1
  sw   $t9, 0($t8)

  # tien thang i = don gia(bac) * usage[i], tinh bang cong lap
  la   $t0, price
  sll  $t1, $t7, 2
  add  $t0, $t0, $t1
  lw   $a1, 0($t0)      # a = don gia
  addi $a2, $zero, 0    # tich = 0
  addi $t0, $zero, 0    # dem = 0
MulLoop:
  beq  $t0, $t5, MulDone
  add  $a2, $a2, $a1    # tich += a
  addi $t0, $t0, 1
  j    MulLoop
MulDone:
  add  $s6, $s6, $a2    # tong tien += tien thang i

  addi $s2, $s2, 1
  j    Loop2

# ---- Phan 3: in 4 dong "Bac k: so thang" va tong tien ----
Print:
  addi $s2, $zero, 0
  addi $s5, $zero, 4
PLoop:
  beq  $s2, $s5, PTien
  li   $v0, 4
  la   $a0, mb
  syscall
  li   $v0, 1
  addi $a0, $s2, 1
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  sll  $t0, $s2, 2
  add  $t0, $t0, $s4
  lw   $a0, 0($t0)
  li   $v0, 1
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall
  addi $s2, $s2, 1
  j    PLoop
PTien:
  li   $v0, 4
  la   $a0, mt
  syscall
  li   $v0, 1
  add  $a0, $s6, $zero
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall
Done:
  li   $v0, 10
  syscall
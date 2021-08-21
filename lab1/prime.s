.data
msg1: .asciiz "Please input integer n: "
msg2: .asciiz "It's not a prime\n"
msg3: .asciiz "It's a prime\n"


.text

.globl main
main:
li 	$v0, 4
la	$a0, msg1
syscall

li	$v0, 5
syscall

add	$a0, $v0, $zero
jal	prime

beq	$v0, $zero, FINISH1
li	$v0, 4
la	$a0, msg3
syscall

li	$v0, 10
syscall

FINISH1:
li	$v0, 4
la	$a0, msg2
syscall

li	$v0, 10
syscall



prime:
slti	$t0, $a0, 1
beq	$t0, $zero, start   
addi	$v0, $zero, 1
jr	$ra

start:
slti	$t0, $a0, 2
beq	$t0, $zero, Real   # if var less than 2 => return 0
add	$v0, $zero, $zero 
jr	$ra

Real:

addi	$sp, $sp, -4
sw	$ra, 0($sp) # store the retuen address
addi	$s0, $zero, 1  # int i=2
LOOP:
addi	$s0, $s0, 1
mul	$s1, $s0, $s0
slt	$t2, $a0, $s1
bne	$t2, $zero, EXIT1

move	$s3, $a0

SUB:
sub	$s3, $s3, $s0
beq	$s3, $zero, EXIT2   #return 0

slt	$t4, $s3, $s0
bne	$t4, $zero, LOOP
jal	SUB





EXIT1: 	#return 1
addi	$v0, $zero, 1
lw	$ra, 0($sp)
jr	$ra

EXIT2:
addi	$v0, $zero, 0
lw	$ra, 0($sp)
jr	$ra

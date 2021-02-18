.data
matrixA:   .float 1.5, -1.2, 2.3, -2.8, 0.7, 3.9, 1.3, 1.3, 1.4, 1.0, 0.5, -1.2, 1.2, -2.1, 1.8
vectorX:   .float 3.2, -1.5, 1.1 # 3 dimension
vectorB:   .float 0.3, -0.5, 1.3, -2.1, 0.1 # 5 dimension
shapeA:    .word 5, 3 # matrix size is 5 x 3
fzero: .float 0.0
str1: .asciiz "\nshape\n"  #
str2: .asciiz "\nmatrix elements at (0,0) and (0,1)\n"  #
str3: .asciiz "\nThe result of y=max(0,A*x+b)\n"  #
enter: .asciiz "\n"
space: .asciiz " "
.text
main:

  # print the values of y,
  # where y = max(0, matrixA * vectorX + vectorB)

  #print "\nshape\n"
  li $v0, 4 # system call code for printing string = 4
  la $a0, str1
  syscall # call operating system to perform operation

  # printing shape
  # print m
  li $v0, 1
  la $s0, shapeA # address of shapeA to $s0
  lw $a0, 0($s0)
  syscall

  #print " "
  li $v0, 4 # system call code for printing string = 4
  la $a0, space
  syscall # call operating system to perform operation

  #print n
  li $v0, 1
  lw $a0, 4($s0)
  syscall

  #print "\nmatrix elements at (0,0) and (0,1)\n"
  li $v0, 4 # system call code for printing string = 4
  la $a0, str2
  syscall # call operating system to perform operation

  # printing the first two elements
  # print first element
  li $v0, 2
  la $s1, matrixA
  lwc1 $f12, 0($s1)
  syscall

  #print " "
  li $v0, 4 # system call code for printing string = 4
  la $a0, space
  syscall # call operating system to perform operation

  #print second element
  li $v0, 2
  lwc1 $f12, 4($s1)
  syscall

  #to print "\n"
  li $v0, 4 # system call code for printing string = 4
  la $a0, enter
  syscall # call operating system to perform operation

  #print "\nThe result of y=max(0,A*x+b)\n"
  li $v0, 4 # system call code for printing string = 4
  la $a0, str3
  syscall # call operating system to perform operation

  #save m and n
  la $s0, shapeA # address of shapeA to $s0
  lw $t0, 0($s0) # t0 = m
  lw $t1, 4($s0) # t1 = n

  #save address
  la $a3, matrixA
  la $a1, vectorX
  la $a2, vectorB

  lw $t0, 0($s0) # t0 = m

  #set parameters to 0
  li $s1, 0 # j = 0
L2:  # outer loop. increase j.
  li $s0, 0 # i = 0

  #print zero
  #li $v0, 2
  la $s2, fzero
  lwc1 $f0, 0($s2)
  
  L1:  # inner loop. increase i

  #to get 4(5i+j)
  mul  $t2, $s0, $t0
  addu $t2, $t2, $s1
  sll $t2, $t2, 2
  addu $t2, $a3, $t2
  l.s $f4, 0($t2)

  li $t3, 0
  #to get 4(i)
  addu $t3, $t3, $s0
  sll $t3, $t3, 2
  addu $t3, $a1, $t3
  l.s $f8, 0($t3)

  li $t7, 0
  #to get 4(j)
  addu $t7, $t7, $s1
  sll $t7, $t7, 2
  addu $t7, $a2, $t7
  l.s $f16, 0($t7)

  #add to sum
  mul.s $f12, $f4, $f8
  add.s $f0, $f0, $f12

  #gather the sum into $f12
  mov.s $f12, $f0

  #add 1 to i, break the loop if equal to n
  addiu $s0, $s0, 1
  beq $s0, $t1, SUM
SUMRETURN:
  bne $s0, $t1, L1

  #add 1 to j, break the loop if equal to m
  addiu $s1, $s1, 1
  bne $s1, $t0, L2

  # terminate program
  li $v0, 10 
    syscall


SUM:
  #save results on stack pointer
  #addi $sp, $sp, -4

  #add results to B vector
  add.s $f12, $f12, $f16

  lwc1 $f24, 0($s2)
  c.lt.s $f12, $f24
  bc1t ZERO

SUMCON:

  #swc1 $f12, ($sp)

  #to print content(sum)
  li $v0, 2
  syscall

  #to print "\n"
  li $v0, 4 # system call code for printing string = 4
  la $a0, enter
  syscall # call operating system to perform operation

  j SUMRETURN

ZERO:
  mov.s $f12, $f24
  j SUMCON

.end

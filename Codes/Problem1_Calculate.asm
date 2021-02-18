.data
digit:   .word 10, 12, 23, 28, 7, 39, 10, 11, 23, 12, 3, 4, 5, 1, 34, 17, 0, 5, 24
length:   .word 19 # the length of the digit list
str1: .asciiz "Enter a char('s':sum, 'x':max, 'n':min, 'q':quit): "
str2: .asciiz "The sum is "
str3: .asciiz "The max is "
str4: .asciiz "The min is "
str5: .asciiz " \n"

# HERE, implement mips code
# to get the sum, max, and min of the ‘digit’ list above
# and to print the results (sum, max, and min)

# the printing format should be as follows:
# sum is xxx
# max is yyy
# min is zzz

.text
main:
    
	la $s1, digit         # s1=digit
	li $s2, 18         # s2=length-1
	li $s3, 0              # s3=0, total sum
	li $s4, 0		      # int i = 0;
	li $t4, 0            # location of max/min
    
    li $v0, 4           # print new line
    la $a0, str5       
    syscall

    la $a0, str1   # print str1
    li $v0, 4
    syscall
  
    li $v0,12 		      # scanf준비
	syscall
	move $t2,$v0 		# scanf완료한 과정, n값을 입력받아낸다.

	li $v0, 4           # print new line
    la $a0, str5
    syscall

	beq $t2, 'q', quit
	beq $t2, 's', addition
	beq $t2, 'x', maximum
	beq $t2, 'n', minimum
	j main

addition:				     
	sll $t3, $s4, 2
	add $t3, $t3, $s1
	lw $t4, 0($t3)

	add $s3, $s3, $t4
	slt $t5, $s4, $s2
	beq $t5, $zero, printsum
	addi $s4, $s4, 1	      # i = i + 1;
	j addition			      # 다시 더한다

maximum:
    sll $t3, $s4, 2
	add $t3, $t3, $s1
	lw $t6, 0($t3)

	slt $t5, $t4, $t6
	bne $t5, $zero, transfermax
	slt $t5, $s4, $s2
	beq $t5, $zero, printmax
	addi $s4, $s4, 1	      # i = i + 1;
	j maximum

minimum:
    sll $t3, $s4, 2
	add $t3, $t3, $s1
	lw $t6, 0($t3)

	slt $t5, $t4, $t6
	beq $t5, $zero, transfermin
	slt $t5, $s4, $s2
	beq $t5, $zero, printmin
	addi $s4, $s4, 1	      # i = i + 1;
	j minimum

transfermax:
    lw $t4, 0($t3)
	slt $t5, $s4, $s2
	beq $t5, $zero, printmax
	addi $s4, $s4, 1	      # i = i + 1;
	j maximum

transfermin:
    lw $t4, 0($t3)
	slt $t5, $s4, $s2
	beq $t5, $zero, printmin
	addi $s4, $s4, 1	      # i = i + 1;
	j minimum

printsum:
    la $a0, str2   # print str2
    li $v0, 4
    syscall

    li $v0, 1      # print sum
	move $a0, $s3   
    syscall
	j main

printmax:
    la $a0, str3   # print str3
    li $v0, 4
    syscall

    li $v0, 1      # print max
	move $a0, $t4   
    syscall
	j main

printmin:
    la $a0, str4   # print str4
    li $v0, 4
    syscall

    li $v0, 1      # print min
	move $a0, $t4   
    syscall
	j main

quit:
.end

.data
array: .word -360,409,320,403,-238,-224,-100,454,-233,-479,-104,145,-448,253,-399,10,-253,348,362,-315,376,-11,54,280,427,-366,349,-34,-466,-58,-454,268,266,-458,434,438,397,-497,-397,-369,-63,338,227,-363,122,275,-470,5,444,91


xuong_dong: .asciiz "\n"
space: .asciiz " "
input: .asciiz "Mang ban dau: \n"
start_sort: .asciiz "Start sorting: \n"
pivot: .asciiz "Pivot: "
element: .asciiz "Low and High is: "
output: .asciiz "Mang sau khi duoc sap xep: \n"
seperate: .asciiz "\n--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n"
.text
.globl main

main:
la $a0,input
addi $v0,$zero,4
syscall

la $t0,array
add $a0,$zero,$t0
addi $a1, $zero, 0 # Set a1 to (low = 0)
addi $a2, $zero, 50 # Set a2 to (high, last index in array)
addi $a2, $a2, -1
move $k0, $a1
move $k1, $a2

jal print

la $a0, start_sort
addi $v0,$zero,4
syscall

la $a0, array

jal quicksort

la $a0,output
addi $v0,$zero,4
syscall

la $a0,array
jal print
li $v0, 10 # Terminate program and exit
syscall


print_element:
	addi $sp, $sp, -4
	sw $v0, 0($sp)
	la $t0, array

	la $a0, element
	li $v0, 4
	syscall
	
	addi $a0, $zero, '\n'
	li $v0, 11
	syscall
###	
	sll $a0, $a1, 2
	add $a0, $a0, $t0
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	
	addi $a0, $zero, '\n'
	li $v0, 11
	syscall
	
	
	sll $a0, $a2, 2
	add $a0, $a0, $t0
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	
	addi $a0, $zero, '\n'
	li $v0, 11
	syscall
	
###
	lw $v0, 0($sp)
	addi $sp, $sp, 4
	la $a0, array
	jr $ra
####

print_pivot:
	addi $sp, $sp, -4
	sw $v0, 0($sp)
	la $t0, array
	
	la $a0, pivot
	li $v0, 4
	syscall
	
	lw $a0, 0($sp)
	sll $a0, $a0, 2
	add $a0, $a0, $t0
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	
	addi $a0, $zero, '\n'
	li $v0, 11
	syscall	
	
	lw $v0, 0($sp)
	addi $sp, $sp, 4
	la $a0, array
	jr $ra


print:
		addi $sp, $sp, -4
		sw $v0, 0($sp)
		la $t0, array
		li $t1, 0
		for:		
			lw $a0, 0($t0)
			
			addi $v0,$zero,1
			syscall

			la $a0,space
			addi $v0,$zero,4
			syscall
			
			beq $t1, $k1, end_for
			addi $t0, $t0, 4
			addi $t1, $t1, 1
			
			j for
			
		end_for:
			la $a0,seperate
			addi $v0,$zero,4
			syscall

			lw $v0, 0($sp)
			addi $sp, $sp, 4
			la $a0, array

			jr $ra

swap:
	sll $t1, $a1, 2     	#t1 = 4a
	add $t1, $a0, $t1	#t1 = arr + 4a
	lw $s3, 0($t1)		#s3 = array[a]

	sll $t9, $a2, 2		#t2 = 4b
	add $t9, $a0, $t9	#t2 = arr + 4b
	lw $s4, 0($t9)		#s4 = arr[b]

	sw $s4, 0($t1)		#arr[a] = arr[b]
	sw $s3, 0($t9)		#arr[b] = arr[a]

	jr $ra

partition:

	addi $sp, $sp, -4	#Make space for 4
	sw $ra, 0($sp)

	move $s1, $a1		#s1 = low
	move $s2, $a2		#s2 = high

	sll $t1, $s2, 2		# t1 = 4 * high
	add $t1, $a0, $t1	# t1 = arr + 4 * high
	lw $t2, 0($t1)		# t2 = arr[high] // pick the rightmost as pivot

	addi $t3, $s1, -1 	#t3, i=low -1
	move $t4, $s1		#t4, j=low
	addi $t5, $s2, -1	#t5 = high - 1

	forloop:
		slt $t6, $t5, $t4	#t6=1 if j>high-1, t7=0 if j<=high-1
		bne $t6, $zero, endfor	

		sll $t1, $t4, 2		# t1 = j * 4
		add $t1, $t1, $a0	# t1 = arr + 4j
		lw $t7, 0($t1)		# t7 = arr[j]

		slt $t8, $t2, $t7	#t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
		bne $t8, $zero, endfif	
		addi $t3, $t3, 1	#i=i+1

		move $a1, $t3		#a1 = i
		move $a2, $t4		#a2 = j
		jal swap		#swap(arr, i, j)

		addi $t4, $t4, 1	#j++
		j forloop

	    endfif:
		addi $t4, $t4, 1	#j++
		j forloop		

	endfor:
		addi $a1, $t3, 1		#a1 = i+1
		move $a2, $s2			#a2 = high
		add $v0, $zero, $a1		#v0 = i+1 return (i + 1);
		jal swap			#swap(arr, i + 1, high);


		jal print_pivot
		jal print
		
		lw $ra, 0($sp)			#return address
		addi $sp, $sp, 4		
		jr $ra				

quicksort:
	addi $sp, $sp, -20		# Make space for 4

	sw $a0, 0($sp)
	sw $a1, 4($sp)			# low
	sw $a2, 8($sp)			# high
	sw $ra, 12($sp)
	
	slt $t1, $a1, $a2		# t1=1 if low < high, else 0
	beq $t1, $zero, endif
	
	#jal print_element
	jal partition
	
	move $s0, $v0
	
	sw $s0, 16($sp)			# pivot, s0= v0

	lw $a1, 4($sp)			#a1 = low
	addi $a2, $s0, -1		#a2 = pi -1
	jal quicksort		

	lw $s0, 16($sp)
	
	addi $a1, $s0, 1		#a1 = pi + 1
	lw $a2, 8($sp)			#a2 = high
	jal quicksort			

 endif:

 	lw $a0, 0($sp)
 	lw $a1, 4($sp)
 	lw $a2, 8($sp)
 	lw $ra, 12($sp)
 	lw $s0, 16($sp)
 	addi $sp, $sp, 20
 	jr $ra


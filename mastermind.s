.data
prompt: .asciz "Enter guess: "
intro:  .asciz "Your mission, should you choose to accept it...\n"
objective: .asciz "Crack the 4-digit code (1–6, no repeats) in 10 attempts.\n"
attempts_msg: .asciz "Black = correct spot, White = correct number wrong spot.\n"
testing: .asciz "Secret code will be shown for testing.\n"
acceptance: .asciz "Accept mission?\n"
value: .asciz "Enter 1 to accept or 0 to decline: "
value_two: .asciz "Enter 1 to play again or 0 to decline: "
win:   .asciz "\nMISSION COMPLETE\n"
lose: .asciz "\nMISSION FAILED\n"
black: .asciz "Black: "
white: .asciz "White: "
attempts_count: .asciz "Attempt: "
secret_label: .asciz "Secret Code: "
invalid_input: .asciz "Enter a valid input(4 numbers, using digits 1-6 no letters): \n "
input_buffer: .asciz "          "
newline: .asciz "\n"

.text
.globl main

main:

    	j print_intro

exit:

    	li a7, 10
    	ecall

# ------------------ INTRO ------------------
print_intro:

    	la a0, intro
    	li a7, 4
    	ecall

    	la a0, objective
    	li a7, 4
    	ecall

    	la a0, attempts_msg
    	li a7, 4
    	ecall

    	la a0, testing
    	li a7, 4
    	ecall

    	la a0, acceptance
    	li a7, 4
    	ecall

    	j ask_to_play

ask_to_play:

	la a0, value
    	li a7, 4
    	ecall

    	la a0, input_buffer
    	li a1, 12
    	li a7, 8
    	ecall

    	la t6, input_buffer
    	lb s0, 0(t6)

    	li s1, 49   # '1'
    	beq s0, s1, initialize_game

    	li s1, 48   # '0'
    	beq s0, s1, exit

    	j ask_to_play
	
# ------------------ INIT ------------------
initialize_game:

# --------------------------------------------
# Original hardcoded version (used for testing)
# li t0, 2
# li t1, 5
# li t2, 1
# li t3, 3
   
# -------- RANDOM CODE GENERATION --------

gen1:
   	li a7, 42
	li a1, 6
	ecall

    	div s7, a0, s6
	mul s7, s7, s6
	sub t0, a0, s7
    	addi t0, t0, 1
	
gen2:

   	li a7, 42
	li a1, 6
	ecall
	
    	div s7, a0, s6
	mul s7, s7, s6
	sub t1, a0, s7
    	addi t1, t1, 1
    	beq t1, t0, gen2

gen3:

    	li a7, 42
	li a1, 6
	ecall
	
    	div s7, a0, s6
	mul s7, s7, s6
	sub t2, a0, s7
    	addi t2, t2, 1
    	beq t2, t0, gen3
    	beq t2, t1, gen3

gen4:

    	li a7, 42
	li a1, 6
	ecall

    	div s7, a0, s6
	mul s7, s7, s6
	sub t3, a0, s7
    	addi t3, t3, 1
    	beq t3, t0, gen4
    	beq t3, t1, gen4
    	beq t3, t2, gen4

    	li t4, 1   

    	j display_secret_code
    	li t4, 1   

    	j display_secret_code
    

display_secret_code:

    	la a0, newline
    	li a7, 4
    	ecall

    	la a0, secret_label
    	li a7, 4
    	ecall

    	mv a0, t0
    	li a7, 1
    	ecall

    	mv a0, t1
    	li a7, 1
    	ecall

    	mv a0, t2
    	li a7, 1
    	ecall

    	mv a0, t3
    	li a7, 1
    	ecall

    	la a0, newline
    	li a7, 4
    	ecall

    	j game_loop

# ------------------ LOOP ------------------

game_loop:

    	j display_attempt_number

display_attempt_number:

    	la a0, newline
    	li a7, 4
    	ecall

    	la a0, attempts_count
    	li a7, 4
    	ecall

    	mv a0, t4
    	li a7, 1
    	ecall

    	la a0, newline
    	li a7, 4
    	ecall

    	j read_guess

# ------------------ INPUT/VALIDATION ------------------
read_guess:

    	la a0, prompt
    	li a7, 4
    	ecall

    
    	la a0, input_buffer
    	li a1, 12
    	li a7, 8
    	ecall

    
    	li t5, 0
    	la t6, input_buffer

convert_loop:

    	lb s0, 0(t6)

    	li s1, 10
    	beq s0, s1, done_convert
    	beq s0, zero, done_convert

    
    	li s1, 48
    	blt s0, s1, invalid_guess

    	li s1, 57
    	bgt s0, s1, invalid_guess

    	addi s0, s0, -48

    	li s1, 10
    	mul t5, t5, s1
    	add t5, t5, s0

    	addi t6, t6, 1
    	j convert_loop

done_convert:

    	li s1, 1000
    	blt t5, s1, invalid_guess

    	li s1, 9999
    	bgt t5, s1, invalid_guess

    	j split_guess_digits
    
invalid_guess:

    	la a0, newline
    	li a7, 4
    	ecall

    	la a0, invalid_input
    	li a7, 4
    	ecall

    	j read_guess

# ------------------ SPLIT ------------------

split_guess_digits:

    	mv t6, t5         

    	li s5, 10          

    	div s7, t6, s5
    	mul s7, s7, s5
    	sub s2, t6, s7
    	div t6, t6, s5

    
    	div s7, t6, s5
    	mul s7, s7, s5
    	sub s1, t6, s7
    	div t6, t6, s5

    
    	div s7, t6, s5
    	mul s7, s7, s5
    	sub s0, t6, s7
    	div t6, t6, s5

    
    	mv s6, t6


	beq s6, s0, invalid_guess
	beq s6, s1, invalid_guess
	beq s6, s2, invalid_guess

	beq s0, s1, invalid_guess
	beq s0, s2, invalid_guess

	beq s1, s2, invalid_guess

    	j compute_feedback
    	
# ------------------ FEEDBACK ------------------

compute_feedback:

    	li s3, 0   
    	li s4, 0   

    	j count_black

count_black:

    	beq t0, s6, b1
    
n1:

    	beq t1, s0, b2
    
n2:

    	beq t2, s1, b3
    	
n3:

    	beq t3, s2, b4
    	
n4:

    	j count_white

b1:

    	addi s3, s3, 1
    	j n1

b2:

    	addi s3, s3, 1
    	j n2

b3:

    	addi s3, s3, 1
    	j n3

b4:

    	addi s3, s3, 1
    	j n4

count_white:

    	beq s6, t1, w1
    	beq s6, t2, w1
    	beq s6, t3, w1
    	
nw1:

    	beq s0, t0, w2
    	beq s0, t2, w2
    	beq s0, t3, w2
    
nw2:

    	beq s1, t0, w3
    	beq s1, t1, w3
    	beq s1, t3, w3
    
nw3:

    	beq s2, t0, w4
    	beq s2, t1, w4
    	beq s2, t2, w4
    
nw4:

    j display_feedback

w1:

    	addi s4, s4, 1
    	j nw1

w2:

    	addi s4, s4, 1
    	j nw2

w3:

    	addi s4, s4, 1
    	j nw3

w4:

    	addi s4, s4, 1
    	j nw4

# ------------------ OUTPUT ------------------

display_feedback:

    	la a0, newline
    	li a7, 4
    	ecall

    	la a0, black
    	li a7, 4
    	ecall

    	mv a0, s3
    	li a7, 1
    	ecall

    	la a0, newline
    	li a7, 4
    	ecall

    	la a0, white
    	li a7, 4
    	ecall

    	mv a0, s4
    	li a7, 1
    	ecall

    	la a0, newline
    	li a7, 4
    	ecall

    	j update_attempts

# ------------------ STATE ------------------

update_attempts:

    	addi t4, t4, 1
    	j check_game_status

check_game_status:

    	li s5, 4
    	beq s3, s5, win_case

    	li s5, 10
    	beq t4, s5, lose_case

    	j display_attempt_number

# ------------------ END ------------------

win_case:

    	la a0, win
    	li a7, 4
    	ecall
    	j ask_play_again

lose_case:

    	la a0, lose
    	li a7, 4
    	ecall
    	j ask_play_again
    
#---------------- PLAY AGAIN ---------------

ask_play_again:

    la a0, newline
    li a7, 4
    ecall

    la a0, value_two
    li a7, 4
    ecall

    li a7, 5
    ecall

    li t0, 1
    beq a0, t0, restart_game

    beq a0, zero, exit

    j ask_play_again
    
restart_game:

    # reset attempts
    li t4, 1

    # jump to fresh game setup
    j initialize_game

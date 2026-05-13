; Simple Math Calculator
; LC3-Based Reverse Polish Notation (RPN) Calculator

; Usage:
; Enter a number 0-9, or an operator +, -, *, or /
; Calculator will use Reverse Polish Notation to calculate
; If there is only one number on stack, operation will fail
; and program will terminate. It will accept up to 4 digits.
; "." will copy the top of the RPN stack into result and terminate
; If stack is empty, operation will fail and program will reset to the beginning

; Algorithm
; 1. Initialize RPN stack and test values 0 - 9, +, -, *, /, and . 
; 2. Print title and instructions
; 3. Read character from keyboard
; 4. If operator, load operator vector, check stack for two numbers 
; 5. If so, execute operator vector and push result on stack, if not, error
; 6. If number, push number onto stack
; 7. If ".", check if stack is empty, if not copy TOS to result, if so, error
; 8. Loop back to 3

; Registers:
; R0 - primary register for operations
; R1 - temp register
; R2 - temp register
; R3 - temp register
; R4 - RPN stack pointer
; R7 - stores return addresses for JSR calls

; Prompts:
;   > - ready to accept a new number
;   ? - error occured, input doesn't make sense
;   $ - stack error occurred
;   ! - numeric overflow or underflow


.orig x3000

START       ld R4, STACK_TOP    ; RPN Stack Pointer Address
            lea R0, MSG1        ; Printing Title and Instruction
            puts
            lea R0, MSG2
            puts
            lea R0, MSG3
            puts
            
LOOP        lea R0, NEW_NUM      ; Asking for a New Number/Operator
            puts
            getc
            out
            add R1, R0, #0      ; Transferring the new number to R1
            ld R0, NEWLINE
            out
            add R0, R1, #0      ; Transferring the number back to R0
            
            ld R1, MULT         ; Setting R1 to "*" and turning it to its negative decimal value
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1      ; If R2 is negative, that means the input is not a valid input (decimal value is too small)
            brn ERROR
            
            ld R1, ASCII_0      ; Setting R1 to ASCII 0 and turning it to its negative decimal value
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1      ; Since we checked the lower bound, anything less than ASCII 0 will be either a valid operator or ","
            brn CHECK_OP
            add R2, R2, #-9     ; If R2 is negative, that means the input is not a valid input (decimal value is too large)
            brp ERROR
            
            ld R1, ASCII_0      ; Resetting R1 to ASCII 0 and turning it to its negative decimal value
            not R1, R1
            add R1, R1, #1
            add R0, R0, R1      ; Converting the ASCII digit to an integer
            add R4, R4, #-1     ; Decrementing the R4 and repeating the Loop until CHECK_OP notices a "." or an error occurs
            str R0, R4, #0      ; Storing the integer in R4 (RPN Stack Pointer)
            brnzp LOOP

S_ERROR     lea R0, STACK_ERROR ; Stack Error
            puts
            ld R0, NEWLINE
            out
            brnzp START         ; Restarting Program

F_ERROR     lea R0, FLOW_ERROR  ; Numeric Overflow or Underflow
            puts
            ld R0, NEWLINE
            out
            brnzp START         ; Restarting Program

ERROR       lea R0, INPUT_ERROR ; Input Error
            puts
            ld R0, NEWLINE
            out
            brnzp START         ; Restarting Program

EXIT        halt

result      .blkw 1             ; Result from the Calculator (Will also be Printed in the Console unless the number is greater than 9 or less than -9)
STACK_TOP   .fill x4000
NEW_NUM     .stringz "> "
INPUT_ERROR .stringz "? "
STACK_ERROR .stringz "$ "
FLOW_ERROR  .stringz "! "
NEWLINE     .fill x000A
MULT        .fill x2A
PLUS        .fill x2B
MINUS       .fill x2D
DIVIDE      .fill x2F
TOS         .fill x2E
ASCII_0     .fill x30

DONE        ld R1, STACK_TOP    ; Checks if the Stack has Extra Numbers
            not R2, R4
            add R2, R2, #1
            add R3, R1, R2      ; Finds the Amount of Numbers in the Stack
            add R3, R3, #-1     ; Finds the Remaining Amount of Numbers in the Stack after taking 1
            brnp S_ERROR        ; brnp checks if there is more than 1 number in the stack or 0 numbers in the stack
            
            ldr R0, R4, #0      ; Takes the current value in R4
            st R0, result       ; Stores it into result
            brn NEGATIVE        ; If it is negative, a negative sign needs to be outputted and the number has to be converted to positive
            add R1, R0, #-9     ; Checks if R0 is greater than 9
            brp DOUBLEDIGIT
BACK        ld R1, ASCII_0      ; Loads in ASCII_0 to convert R0 to ASCII
            add R0, R0, R1
            out                 ; Prints out the ASCII of whatever number is R0
            brnzp EXIT

CHECK_OP    ld R1, TOS          ; Checking if the Operator is "."
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1
            brz DONE
            
            ld R1, STACK_TOP    ; Checks if the Stack has 2 Available Numbers to use for the Operation
            not R2, R4
            add R2, R2, #1
            add R3, R1, R2      ; Finds the Amount of Numbers in the Stack
            add R3, R3, #-2     ; Finds the Remaining Amount of Numbers in the Stack after taking 2
            brn S_ERROR
            
            ld R1, MULT         ; Checking if the Operator is the Multiplication Symbol
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1
            brz MULTIPLY
            
            ld R1, PLUS         ; Checking if the Operator is the Addition Symbol
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1
            brz ADDITION
            
            ld R1, MINUS        ; Checking if the Operator is the Subtraction Symbol
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1
            brz SUBTRACTION
            
            ld R1, DIVIDE       ; Checking if the Operator is the Division Symbol
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1
            brz DIVISION
            
            brnzp ERROR         ; Input is "," which is an disallowed input
            
NEGATIVE    add R1, R0, #9      ; Checks if R0 is less than -9
            brn DOUBLEDIGIT
            
            ld R0, MINUS        ; Outputs a negative sign
            out
            ld R0, result       ; Negates R0 AFTER it is already stored in result
            not R0, R0
            add R0, R0, #1
            brnzp BACK          ; Returns to where it was originally, but positive

DOUBLEDIGIT lea R0, MSG4        ; Prints that the number is greater than 9 or less than -9 in console
            puts
            brnzp EXIT

MULTIPLY    jsr POP2            ; Retrieving the 2 Most Recent Additions to the Stack
            and R0, R0, #0      ; Sum of Repeated Addition to find the Product of R1 and R2
M_LOOP      add R2, R2, #0      ; Checking if R2 is at zero to end the loop
            brz PUSH            ; Putting the new Number into the Stack
            add R0, R0, R1      ; Repeated Addition
            add R2, R2, #-1     ; Decrementing R2 until it is 0
            brnzp M_LOOP

ADDITION    jsr POP2            ; Retrieving the 2 Most Recent Additions to the Stack
            add R0, R1, R2      ; Adding 2 Most Recent Numbers in the Stack
            brnzp PUSH          ; Putting the new Number into the Stack

SUBTRACTION jsr POP2            ; Retrieving the 2 Most Recent Additions to the Stack
            not R2, R2          ; Negating R2
            add R2, R2, #1
            add R0, R2, R1      ; Adding R1 and the Negation of R2
            brnzp PUSH          ; Putting the new Number into the Stack

DIVISION    jsr POP2            ; Retrieving the 2 Most Recent Additions to the Stack
            add R3, R2, #0      ; Checking if R2 is 0
            brz ERROR           ; If R2 is 0, then Division by 0 which is an Error
            and R0, R0, #0      ; Counter of the amount of times R2 subtracts into R1
D_LOOP      not R3, R2          ; Negating R2 into R3
            add R3, R3, #1
            add R1, R1, R3      ; Addition of R1 and Negation of R3
            brn PUSH            ; If R1 is not negative yet, the loop repeats, otherwise puts the new Number into the Stack
            add R0, R0, #1      ; Incrementing R1
            brnzp D_LOOP

PUSH        add R4, R4, #-1     ; Decrementing the Stack
            str R0, R4, #0      ; Storing the New Number into the Stack
            brnzp LOOP

POP2        ldr R2, R4, #0      ; Retrieving the Last Number in the Stack
            add R4, R4, #1      ; Incrementing the Stack
            ldr R1, R4, #0      ; Retrieving the Next Last Number in the Stack
            add R4, R4, #1      ; Incrementing the Stack
            ret

MSG1        .stringz "SMC RPN Calculator\n"
MSG2        .stringz "Enter 0-9 or +, -, *, /, or . to display result on TOS.\n"
MSG3        .stringz "It will accept up to 4 numeric digits and perform operations.\n"
MSG4        .stringz "Number is greater than 9 or less than -9, check result."
.end
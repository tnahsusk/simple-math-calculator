# Simple Math Calculator
## Description
### Operators
This LC3-based Reverse Polish Notation (RPN) calculator will accept numbers with up to 4 digits and perform operations:
- \+ - add two numbers on the stack and place the result on the stack
- \- - add two numbers on the stack and place the result on the stack
- \* - add two numbers on the stack and place the result on the stack
- / - add two numbers on the stack and place the result on the stack
- . - print the number on the top of stack
### Prompts
The calculator will show the following prompts:
- \> - ready to accept a new number
- ? - error occurred, input doesn't make sense
- $ - stack error occurred
- ! - numeric overflow or underflow
### How to Use
At the beginning of hte program, the calculator will display a title nad a short series of subheadings to describe how to use it.
```
SMC RPN Calculator
Enter 0-9 or +, -, *, /, or . to display result on TOS.
```
## Conditions
### Input
1. Only numbers and "." will be recognized, all other characters will be ignored.
2. If only one number on top of stack (TOS), then a math operator input, an error prompt will be displayed.
3. The print operator "." will display TOS, even if it is the only number on the stack.
### Output
1. See Prompts
2. Upon error prompt, the program will be reset to the beginning
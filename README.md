## Chessboard Escape

I don't share solutions to assignments, in general. Let this one be the exception.
What makes it special is that it wasn't my assignment. And it is the only program I have ever written in Pascal.

And what makes you write a program in a language you are not familiar with for an assignment that has nothing to do with you?
Yes, the answer is: a girl.

I met her in a French language class. We would discuss random stuff, including our studies.
Eventually, she said she was struggling with a programming exercise on recursion.
I wanted to impress her by coding it myself and to ask her out, the perfect excuse for which would be the explanation of recursion used in the code.
The impression part worked well: she proclaimed me a demigod. (It doesn't get any better than that, since she believed in the only God.)
The date part didn't happen, though. It turned out she didn't care about recursion at all!

Let this repository stand a testament to my foolish judgement.

My notes on Pascal:
-   a semicolon `;` is a statement *separator*, not a statement *terminator*.
-   arguments declared as `var` are passed by reference. The function or procedure must then be called with a variable, not a literal, which makes sense.
-   in order to pass a pointer to a specific type, a new type must be defined:
    ```pascal
    type
        pMyType = ^MyType;
    ```
    this is useful e.g. if you want to access the fields of a pointed-to record inside the function or procedure.
    Obviously, the general `pointer` type is not sufficient, and the compiler won't take the parameter type `^MyType`, which does not make sense to me.
-   Pascal is not case-sensitive.

## The Problem

Consider a chessboard (size 6x6, indexed x:1..6, y:1..6).

There can be pieces of four types:
-   **L** going left (in a move, x-coordinate is decreased by 1)
-   **P** going right (in a move, x-coordinate is increased by 1)
-   **N** going up (in a move, y-coordinate is decreased by 1)
-   **D** going down (in a move, y-coordinate is increased by 1)

When a piece moves outside of the chessboard, it successfully escapes.

The game progresses in steps. In each step, any number of pieces can do a move.
After a step, there cannot be multiple pieces on the same square.
A piece can, however, occupy a square that was vacated in the same step by another piece.
In this manner, two pieces advancing in opposite directions can even jump over each other.

What is the minimal number of steps needed for all pieces to successfully escape the board?

input:
The first line contains a number of pieces.
Every following line contains one piece: its type, x-coord, y-coord.

## Solution

Since this was *probably* an exercise on recursion, it is solved by recursion.
The set of possible moves of each piece is very limited. Therefore, there is no tree search. Just a heuristic:
we prioritize moving pieces that have the longest way to go, and recursively we make room at the target squares.
In this manner, possible collisions are avoided, optimizing (no proof) the escape time.

### example 1
input
```
2
L 4 1
N 1 4
```
output
```
step: 0
 -  -  -  L  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 N  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 1
 -  -  L  -  -  - 
 -  -  -  -  -  - 
 N  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 2
 -  L  -  -  -  - 
 N  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 3
 L  -  -  -  -  - 
 N  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 4
 N  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 5
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
number of steps: 5
```


### example 2
input
```
6
P 1 3
P 2 3
P 3 3
L 4 3
L 5 3
L 6 3
```
output
```
step: 0
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 P  P  P  L  L  L 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 1
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 P  P  L  P  L  L 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 2
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 P  L  P  L  P  L 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 3
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 L  P  L  P  L  P 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 4
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  L  P  L  P  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 5
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 L  -  L  P  -  P 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 6
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  L  -  -  P  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 7
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 L  -  -  -  -  P 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 8
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
number of steps: 8
```


### example 3
input
```
3
L 6 4
N 5 5
D 5 4
```
output
```
step: 0
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  D  L 
 -  -  -  -  N  - 
 -  -  -  -  -  - 
##################
step: 1
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  N  L 
 -  -  -  -  D  - 
 -  -  -  -  -  - 
##################
step: 2
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  N  - 
 -  -  -  -  L  - 
 -  -  -  -  -  - 
 -  -  -  -  D  - 
##################
step: 3
 -  -  -  -  -  - 
 -  -  -  -  N  - 
 -  -  -  -  -  - 
 -  -  -  L  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 4
 -  -  -  -  N  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  L  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 5
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  L  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 6
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 L  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 7
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
number of steps: 7
```


### example 4
input
```
4
L 3 2
D 2 2
P 2 3
N 3 3
```
output
```
step: 0
 -  -  -  -  -  - 
 -  D  L  -  -  - 
 -  P  N  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 1
 -  -  -  -  -  - 
 -  L  N  -  -  - 
 -  D  P  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 2
 -  -  N  -  -  - 
 L  -  -  -  -  - 
 -  -  -  P  -  - 
 -  D  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 3
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  P  - 
 -  -  -  -  -  - 
 -  D  -  -  -  - 
 -  -  -  -  -  - 
##################
step: 4
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  P 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  D  -  -  -  - 
##################
step: 5
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
 -  -  -  -  -  - 
##################
number of steps: 5
```


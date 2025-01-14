TUTORIAL 5: Augmented data structures
=====================================

Interval trees:
--------------

Toy example #1:

I want to book a conference room from 16:00 to 17:00. 
Does this time conflict with any previous bookings?

The current bookings are:
9:00 to 9:30
10:00 to 12:00
12:30 to 13:00
14:00 to 15:00
16:30 to 19:30 

Toy example #2:

Does my lifeguarding shift overlap with anyone else's shift?
If so, which one?
Given: I am a lifeguard from 9:00 to 12:00.
The other shifts are: 6:00 to 8:00, 10:00 to 13:00, 12:00 to 15:00 
and 14:00 to 17:00

Definitions:
-----------

Closed interval: an ordered pair of real numbers [t1,t2] with t1 <= t2

Given closed interval i and i', do they overlap?

Yes:  |---------| i     |------| i        |-------| i         |-----| i
        |--| i'       |-----------| i'      |--------| i'       |------| i'


No: |-------| i             and                 |-------|i
              |-------| i'         |------| i'


low endpoint: low[i] = t1
high endpoint: high[i] = t2

Two intervals overlap if i \cap i' \neq \emptyset.
(In other words, low[i] <= high[i'] AND low[i'] <= high[i].)


Goals:
------
1) Store a set (S) of intervals in some data structure
2) Suppose the following interval operations:

   INSERT(S,x): given a pointer to element x, add x to the interval set S 

   DELETE(S,x): given a pointer to element x, remove x from S

   SEARCH(S,x): given a pointer to an element x, return a pointer y  
   to an element in S such that the intervals stored in x and y overlap 
   OR return NULL if no element in S overlaps with the interval in x.

All operations should take O(log n) time in the worst-case where n is the 
number of intervals in the tree.

Use an augmented data structure to satisfy the requirements above.

============================================================

Step 1: Which data structure should you use?
Answer: Augmented AVL tree.

Why? i) Dictionary supports insert and delete
     ii) AVL operations have worst-case running time in O(log n)

------------------

Step 2: What information should be stored in the AVL tree? 

Each node x contains the following fields:

int[x]: the interval 
Recall: low[int[x]] = low endpoint and high[int[x]] = high endpoint

max[x]: the maximum high endpoint of any of the intervals stored in the
subtree rooted at x (including x)
  
pointers to the left, and right children and to its parent

balance factor


Question: What field of x should we use as the key?
Answer: Use low[int[x]]  


Example:

            [12.5 , 13 ]  (0)
                19.5
              /       \
    (-1)  [10, 12]     [14.5, 19.5] (-1)
             12             19.5
          /                 /
    (0) [9, 9.5]         [14,15] (0)
          9.5               15
          

Notice: An inorder traversal of the tree lists the intervals in order
of increasing low endpoint.

------------------
 
Step 3: Can we maintain max[x] "cheaply"?
Answer: To update the max value at x, we can use the formula:
max[x] = max(high[int[x]], max[left[x]], max[right[x]])

-> we can update max[x] at node x in constant time

Question: How do we implement INSERT and DELETE?

Answer: use the AVL insert and delete modified to update the max field

Notice: only the nodes along the path from the inserted node/delete leaf
need to have their max field updated (plus nodes involved in a rotation).
-> update max field at the same time as balance factors
-> at most O(log n) max field updates per insert or delete

Therefore, INSERT and DELETE still have worst-case running time in 
O(log n)  

Step 4: How do we implement SEARCH?

SEARCH(T,x)
 y = root(T)
 while y \neq NULL and (x and y do not overlap)
       if left[y] \neq NULL and max[left[y]] \geq low[int[x]]
             then y = left(y)
             else y = right(y)
 return y


Search examples:

              [5 , 10 ]  
                 30 
              /       \
          [3, 9]     [8, 11] 
            9           30 
         /     \        /      \
     [2, 4]  [4, 5]  [7, 30]  [10, 20]
       4        5      30       20


1. Search(T, [0,1])
2. Search(T, [12,13])


Worst-case running time of SEARCH(T,x)?

for any search on a tree with n nodes:
	-> we loop at most log n + 2 times 
	(i.e., we traverse examine at most the nodes along one path 
	from the root to a leaf node.) 
        -> each loop is constant time
        -> SEARCH(T,x) has worst-case running time in O(log n)

in a "bad" search, the interval we are looking for is in a leaf node:
        -> we loop at least log n times for this "bad" input
        -> SEARCH(T,x) has worst-case running time in Omega(log n)

Thus, worst-case running time of SEARCH(T,x) is Theta(log n)


If you have time:
=================

Claim: An overlapping interval will definitely be found if one exists
in the tree.

Outline of proof (complete proof on page 315)

Case 1: SEARCH returns an interval.
        -> interval found :)

Case 2: SEARCH return NULL

 loop invariant: If T contains an interval overlapping x, 
 then an overlapping interval exists in the subtree rooted at y.

 A) at the root, invariant holds
 B) after each iteration of while loop
    i) if left(y) = NULL then there is no left subtree, 
	so y = right(y) is correct
    ii) if max[left[y]] < low[int[x]] then the maximum value of any high 
	endpoint stored at the subtree rooted at left[y] is less than
	the low endpoint of x:

intervals in left subtree              x

    |-------------|            :     |-----|
      |--------------|         :
   |---------------|           :
                    |------|   :

-> no interval in the left subtree overlaps with x
-> if an interval overlaps it must be in the right subtree

    iii) if max[left[y]] \geq low[int[x]] then some interval, say I,
	in the left subtree has high[I] \geq low[int[x]]

cases:   a) |---------| I    b)   |--------| I    c)       |------| I
             |---| i          |------| i             |---| i

        For a) and b), the loop invariant holds 

        For c), high[int[x]] < low[I] 
        Recall: - the low endpoint is the key field  
                - I is in the left subtree of y
         -> all low endpoint in the right subtree of y must be greater
            than low[I]
         -> i will not overlap any interval in the right subtree of y
         -> y = left(y) is correct


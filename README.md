# Tips and Tricks

## Search and Replace
- * : match all the words under the cursor
    - n : next instance
    - shift + n : prev instance
- c i w : delete the word and insert mode
- . : apply the format
(ex: */ciw/n/. change the occurances of the word one by one)

## Registers
- :reg : shows registers
- "/<letter or number>/y - get the content from register

## Macro
1. q (start macro)
2. any letter (at a letter)
3. q (end macro)
4. @ + letter (apply macro)

## Project wide search and replace
1. live grep
2. ctrl+q - to qickfix list
3. :cfdo %s/find/replace/g | update | bd


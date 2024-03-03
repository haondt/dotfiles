# Git

## Conflicts
#merge
Conflicts are presented as such:

<<<<<<< yours.txt
the text as it is seen on your copy
|||||||| hash of common ancestor
the text before it diverged
========
the text as it is seen on their copy
>>>>>>>> theirs.txt

## nvimdiff
#merge
nvimdiff can be launched with `git mergetool`. It will present the conflict in three numbered windows

+----------------+----------------+----------------+
|                |                |                |
|                |                |                |
|   (1) local    |   (2) common   |   (3) remote   |
|    (yours)     |    ancestor    |    (theirs)    |
|                |                |                |
+----------------+----------------+----------------+
|                                                  |
|                                                  |
|                   working copy                   |
|                                                  |
|                                                  |
+--------------------------------------------------+

## dol
#diff
diff obtain local

## dor
#diff
diff obtain remote

## doa
#diff
diff obtain all
just removes git markers, leaving all 2 or 3 changes present


# Git

## Conflicts
#merge
Conflicts are presented as such: 

```
<<<<<<< yours.txt
the text as it is seen on your copy
|||||||| hash of common ancestor
the text before it diverged
========
the text as it is seen on their copy
>>>>>>>> theirs.txt
```

## git mergetool
#mergetool #nvimdiff #gm
nvimdiff can be launched with `git mergetool`. It will present the conflict in three numbered windows

Aliased to `gm`

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

## git difftool --dir-diff
#gd
view diffs in vim. good for diffing two branches or tags:

Aliased to `gd`

compare HEAD with tag `v1.0.0`
```shell
git difftool v1.0.0
```

compare two commits
```shell
git difftool hash1..hash2
```


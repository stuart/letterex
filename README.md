Letterex
========

Letterex is a game where letters appear and
players can choose them to form words.

Letters appear from shuffled words, though
any words may be made. A number of words equal to 
the number of players is shuffled together at one time. 

If multiple players choose the same letter
the first one that makes a word with those
letters gets them. 

_variant_ If multiple players choose the same letter
they can bid 'coins' for it.

Each player has a "rack" into which letters
are put, they start with a rack of 4 letters
and can get larger ones as the game progresses.

Each letter has a color associatied, there are 6 colors:
  red, orange, yellow, green, blue, violet
  plus a special golden letter.

Babel mode: letters come from various alphabets
and words from various languages.

Scoring:
  Word of n letters: (letter values added) ^(k * n)
  k a constant to be determined.
  
  [e, t, a, o, i, n, s ] => 1 6% - 12%
  [h, r, d, l, c, u] => 2 3% - 6%
  [m, w, f, g, y, p] => 4 1.5% - 3%
  [b, v, k] => 8  0.75% - 1.5%
  [j, x, q, z] => 16 < 0.75%
  
  Golden letter: double score for word.
  Last letter: double score for that letter.
  All one color: 2x
  All colors: 2x (min 6 letters)
  Each letter of the 'trump' color: 2x per letter.
  
  
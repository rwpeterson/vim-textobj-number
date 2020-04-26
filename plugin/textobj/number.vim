" textobj-number - Text object for numbers
" Version: 0.0.1
" Copyright (C) 2020 Bob Peterson
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

if exists('g:loaded_textobj_number')
    finish
endif

" Matches any decimal number in float style (i.e. no digit grouping),
" including bare ones like .1, and supporting padded zeros
let s:FLOAT = '-\=\d*\%(\%(\.\|,\)\d\+\)\=\%(\d\)\@<='
"              ^   ^        ^                 ^
"              |   |        |                 |
"              1   2        3                 4
"
" 1. Match a minus sign (or not)
" 2. Match a whole number with zero-padding (or not)
" 3. Match decimal point/comma and fractional part (or not)
" 4. Lookback to match at least one digit, since all of the above is optional

" Snippet optionally matching e notation, e.g. [1.05]e-34 (must match the significand separately)
let s:E = '\%(\%(e\|E\)-\=\d\+\)\='
"                ^     ^   ^     ^
"                |     |   |     |
"                1     2   3     4
"
" 1. Accept e or E as delimeter for notation
" 2. Match a minus sign in the exponent (or not)
" 3. Match whole-number exponent
" 4. This entire snippet is optional, since using e notation is optional

" Snippet optionally matching common currency symbols, ISO 4217 currency codes, and common
" dollar currencies abbreviated on the pattern C$, NZ$, etc.
let s:CURRENCY = '\%(\%([$£€¥₿¤]\|\u\{3}\|\u\{1,3}$\) \=\)\='

" Snippet optionally matching suffixes such as ¢, k, M, B, T, and ordinals
let s:SUFFIX = '\%([¢kMBT]\|st\|nd\|rd\|th\)\='

" Matches written numbers with US, European, or ISO digit-grouping, with
" optional initial minus sign.
let s:STYLED = '-\=\d\{1,4}\%([\., ]\d\{3}\)*\%([\.,]\d\+\)\='

" Matches written numbers with US, European, or ISO digit-grouping, with
" optional initial minus sign and currency symbol/code, and optional suffix.
let s:STYLED_C = '-\='
\                . s:CURRENCY
\                . '\d\{1,4}\%([\., ]\d\{3}\)*\%([\.,]\d\+\)\='
\                . s:SUFFIX

" Matches written values of hex, oct, and bin:
let s:HEX = '0[xX]\x\+'
let s:OCT = '0[oO]\o\+'
let s:BIN = '0[bB][01]\+'

" Regex for inside text object
let s:NUMBER = '\%('
\              .        '\%(' . s:FLOAT . s:E . '\)'
\              . '\|' . '\%(' . s:STYLED . '\)'
\              . '\|' . '\%(' . s:HEX . '\)'
\              . '\|' . '\%(' . s:OCT . '\)'
\              . '\|' . '\%(' . s:BIN . '\)'
\              . '\)'

" Regex for around text object
let s:NUMBER_C = '\%('
\              .        '\%(' . s:FLOAT . s:E . '\)'
\              . '\|' . '\%(' . s:STYLED_C . '\)'
\              . '\|' . '\%(' . s:HEX . '\)'
\              . '\|' . '\%(' . s:OCT . '\)'
\              . '\|' . '\%(' . s:BIN . '\)'
\              . '\)'

" TODO: Currently this works similar to kana's textobj-datetime, which does
" not distinguish between "around" and "inside". Passing a single regex to
" textobj#user#plugin would need to be replaced by separate functions for a
" and i.
call textobj#user#plugin('number', {
\   'number': {
\       'pattern': s:NUMBER,
\       'select': ['an', 'in'],
\   },
\   'currency': {
\       'pattern': s:NUMBER_C,
\       'select': ['a$', 'i$'],
\   },
\})

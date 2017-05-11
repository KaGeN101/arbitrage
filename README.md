# Arbitrage

Finds the maximum arbitrage possible by looking at taking a currency through all the possible conversion paths.

It ignores the fees and other process involved in the real world that probably makes this amount of transactions impossible.

DISCLAIMER: The return on investment seems very high there is probably a bug in the calculation 8-0 

## Installation

http://elixir-lang.org/install.html#unix-and-unix-like

#### Environment

 OS: Ubuntu 16.04 LTS
 Elixir:
   - Erlang/OTP 19 [erts-8.3] [source-d5c06c6] [64-bit] [smp:2:2] [async-threads:10] [hipe] [kernel-poll:false]
   - Elixir 1.4.1 


## Overview

In its most basic form this algorithm brute forces the outcomes of converting a 1000 untis of the base currency to each oher currency available in it table 
and then at the end back to the base from the final currency to see what the retrun was.
It only does the linear path and not all the permutations availble(this is probably not ideal, but does enough to proof something :-/). 
Should be easy enough to extend to include the other permutations. 

#### Future Release

Work out all possible permutations of every currency. 
This is quite a big number but will be done concurrently for as many resources are available to use as this is the power of Elixir. 
For fun would probably spin up cattle on a cloud provider to see how fast this can be done. 

#### Algorithm

All actions are done with recursion(this is the natural way Elixr operates).
It does this in the following steps:
  - Gather: Gets all the available currnecies the base can convert to using http://api.fixer.io and download its exchange table and then each exchange table for every other currency and caches this.
  - Normalise: Takes the base currency linearly to each avalaible currency through all premutations avaliable and stores how much untis you have in the last curreny.
      - ie ```Base->A-B-C->unts in C, Base->B->C->A->units in A, Base->C->A->B->units in B```
      - Not Done: ```Base->A-C-B-units in B, Base->B->A->C->untis in C, Base->C->B->A->untis in A```
      - It does the following equation: ```[Base * Ea] = [Ra * Eb] = [Rb * Ec] ... [Ri * Ei+1]``` = Untis left in Currency(i + 1)    
  - Work Back: Takes all the untis left in the final currency back to how much units you now have in the base currency
  - Maximise: Takes the abritraged amounts with the most return hand returns that

## Running

It does not brew to any executable yet but can easily be run through Mix. In the project folder you can run:
```
mix run -e 'Arbitrage.CLI.run(["CURRENCY"])'
```
Replace CURRENCY with any 3 character currency on fixer.io, e.g: ZAR, USD, GBP etc etc

#### Tests
```
mix test
```




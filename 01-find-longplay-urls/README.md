The goal of this step is to create a list of URLs to all youtube videos containing
SNES longplays from the "World Of Longplays" channel.

## 0. Get Youtube Api Key

Google for directions.  Briefly, in the google developer console, create a new project,
then enable access to the "Youtube Data v3" API.  In Credentials, create an API key.

## 1. Get raw list of youtube videos from the world of longplays channel.

Insert your API key into `youtube-channel-lister.py` (temporarily, don't commit it!).
Then run `./youtube-channel-lister.py > raw-longplay-videos`.

## 2. Parse the raw list into a json file we can use.

We want to (1) Filter to only SNES videos, (2) Group multiple videos that belong to
one game, and (3) output in json format.

Run `./raw-parser.exs`, which will read `raw-longplay-videos` and write out 
`parsed-snes-longplay-vids.bin`.  You should see a list of 500 games or so
print to console when running it, or else it didn't work.

## We're done!

Ok, we've figured out a list of SNES games that have longplay videos available
and what their youtube video ids are for each of them.  Our next step
will be in another directory, we will need to download them all and make screenshots..

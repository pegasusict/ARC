# ARC V0.0.2-DEV
Audio Repository Cleaner is a bash script which cleans out your music collection.

### Depends: 
 * Bash 4+
 * [Pegasus' Bash Functions Library](https://github.com/pegasusict/pbfl)
 * GNU find
 * fdupes

### About
ARC is designed to clean up a repository (one or more directories/discs) containing audio files.
Currently it performs the following actions on set repository:
 1. remove any non-audio files and unneeded directories
 2. purge empty files & directories
 3. delete binary duplicate files
 4. delete any audio files which end with ($i) where $i is a value between 1 and 20
    
 *Step 4 is done as Picard, which I use to analyze and sort my collection, uses this method to indicate duplicates.
  I'll publish my Picard filenaming script soon and insert a link  here.*

### Roadmap
 * ini-style config file & commandline arguments
 * eliminate cross filetype duplicates based on quality
 

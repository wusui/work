===========================================================================
Nightlycensus -- Figure out what teuthology tasks have run during nightlies
===========================================================================

Currently this code runs on teuthology.front.sepia.ceph.com

It consists of two scripts.

- teuth_find.py: Finds the last seven days worth of runs and saves the files
                 in a local data directory

- combine.py: Creates a file, combine.yaml, that is a sum of all the information
              in the local data directory


#!/bin/bash -ue
raxmlHPC -f d -j -p 9 -T 2 -m PROTGAMMALG -s BB11021.phy BB11029.phy BB11001.phy BB11025.phy BB11013.phy -n [BB11021, BB11029, BB11001, BB11025, BB11013]

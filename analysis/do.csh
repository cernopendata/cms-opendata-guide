#foreach file(luminosity.md  )
foreach dir(backgrounds datasim interpretation selection systematics)

    mkdir $dir

end

foreach file(backgrounds/qcdestimation.md backgrounds/techniques.md datasim/collisiondata.md datasim/eventgeneration.md datasim/mcsimulations.md interpretation/limits.md interpretation/stats.md selection/objectid.md selection/objects.md selection/triggers.md systematics/lumiuncertain.md systematics/mcuncertain.md systematics/objectsuncertain.md systematics/pileupuncertain.md)

    echo $file

    echo "# " $file > $file
    echo '\!\!\! Warning' >> $file
    echo "    This page is under construction" >> $file

end




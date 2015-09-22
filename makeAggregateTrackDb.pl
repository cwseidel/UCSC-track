#!/usr/bin/perl

# get header
$header = <>;
$header =~ s/[\n\r\"]//g;
@headers = split(/\t/,$header);

# find header fields
# FileName type track shortLabel longLabel
foreach my $i (0..$#headers) {
    $FileName = $i if($headers[$i] eq "FileName");
    $type = $i if($headers[$i] eq "type");
    $track = $i if($headers[$i] eq "track");
    $shortLabel = $i if($headers[$i] eq "shortLabel");
    $longLabel = $i if($headers[$i] eq "longLabel");
    $color = $i if($headers[$i] eq "color");
    $parent = $i if($headers[$i] eq "parent");
}

$count = 0;
%table = ();
@lines = ();
while($line = <>){
    $line =~ s/[\n\r\"]//g;
    push(@lines, $line);
    @fields = split(/\t/,$line);

    $parent_value = $fields[$parent];
    # capture line numbers by parent
    push( @{$table{$parent_value}}, $count);
    ++$count;
}

foreach $parent_value (sort keys %table){
#    print "$parent_value parent stanza\n\n";
    &printParent($parent_value);
    foreach $line_number (sort @{$table{$parent_value}}){
	&printChild($lines[$line_number]);
#	print "  ",$lines[$line_number], "\n";
    }
    print "\n";
}



sub printParent {

    my ($pname) = @_;
    print "track $pname\n";
    print "container multiWig\n";
    print "shortLabel $pname\n";
    print "longLabel $pname\n";
    print "aggregate transparentOverlay\n";
    print "showSubtrackColorOnUi on\n";
    print "type bigWig -800 800\n";
    print "viewLimits -15:15\n";
    print "maxHeightPixels 200:50:10\n";
    print "\n";
}

sub printChild {

    my ($FileName,$type, $track, $shortLabel, $longLabel, $color, $parent) = split(/\t/,@_[0]);

    print "  track $track\n";
    print "  parent $parent\n";
    print "  shortLabel $shortLabel\n";
    print "  longLabel $longLabel\n";
    print "  bigDataUrl $FileName \n";
    print "  type bigWig\n";
    print "  color $color\n";
    print "\n";

}

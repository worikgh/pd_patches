#!/usr/bin/perl -w
use strict;

## Initialse the midi connections

# Find the midi numbers of the WORLDE, Launchpad X, and Pure Data

my @aconnect_l = `aconnect -l`;
print @aconnect_l;
print scalar(@aconnect_l)." lines\n";
my @wdd = grep {defined} map {/^client\s(\d+): 'WORLDE'/; $1} @aconnect_l;
@wdd == 1 or die "Too many entries for worlde";
my $worlde_device = $wdd[0];
my @lpd = grep {defined} map {/^client (\d+): 'Launchpad X'/} @aconnect_l;
@lpd == 1 or die "Too many entries for Launchpd X";
my $launchpad_x_device = $lpd[0];

my @pdd = grep {defined} map {/^client (\d+): 'Pure Data'/} @aconnect_l;
@pdd == 1 or die "Too many entries for Pure Data: " . scalar(@pdd);
my $pure_data_device = $pdd[0];

print "\$worlde_device $worlde_device. \n\$launchpad_x_device $launchpad_x_device. \n\$pure_data_device $pure_data_device\n";

## Delete connections to and from pure data
sub del_con( $$ ) {
    my ($l, $r) = @_;
    print `aconnect -d $l $r`;
}

&del_con("$worlde_device:0", "$pure_data_device:0");
&del_con("$worlde_device:0", "$pure_data_device:1");
&del_con("$launchpad_x_device:0", "$pure_data_device:0");
&del_con("$launchpad_x_device:1", "$pure_data_device:0");
&del_con("$launchpad_x_device:0", "$pure_data_device:1");
&del_con("$launchpad_x_device:1", "$pure_data_device:1");
&del_con("$pure_data_device:2", "$launchpad_x_device:0");
&del_con("$pure_data_device:2", "$launchpad_x_device:1");
&del_con("$pure_data_device:2", "$worlde_device:0");

## Make new connections
sub make_con( $$ ) {
    my ($l, $r) = @_;
    print `aconnect  $l $r`;
}

&make_con("$worlde_device:0", "$pure_data_device:1");
&make_con("$launchpad_x_device:0", "$pure_data_device:0");
&make_con("$launchpad_x_device:1", "$pure_data_device:0");
&make_con("$pure_data_device:2", "$launchpad_x_device:0");
&make_con("$pure_data_device:2", "$launchpad_x_device:1");
&make_con("$pure_data_device:2", "$worlde_device:0");

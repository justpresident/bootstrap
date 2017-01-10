#!/usr/bin/perl

use warnings;
use strict;

my $num = shift;

print_bits($num);

sub print_bits {
    my $num = shift;
    my $bitnum = shift || 0;

    if($num) {
        print "$bitnum: " . ($num & 1) . "\n";
        return print_bits($num >> 1, $bitnum + 1);
    }
}

1;



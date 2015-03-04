#!/usr/bin/perl -w

my $divider = shift || ",";
my $quote = shift;
while (<STDIN>) {	
	chomp;
	$_ =~ s/^\s*//;
	$_ =~ s/\s*$//;
	next if $_ eq '';
	if (defined $quote) {
		$_ = $quote . $_ . $quote;
	}
	push @list, $_;
}
print "\n\n" . join($divider, @list) . "\n";


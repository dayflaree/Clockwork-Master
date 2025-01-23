# TacoScript 2 - official!
use strict;
my @files = (glob('gamemode/*.?ua'), glob('gamemode/*/*.?ua'), glob('gamemode/*/*/*.?ua'), glob('gamemode/*/*/*/*.?ua'), glob('gamemode/*/*/*/*/*.?ua'));

my $GREP = 'query';
print "Grepping for $GREP\n";
my $found = 0;

for (@files) {
	open (my $FH, $_);
	my @ls = <$FH>;
	my $str = join '', @ls;
	if ($str =~ /$GREP/i) {
		my $i = 0;
		for my $l (@ls) {
			++$i;
			if ($l =~ /$GREP/i) {
				++$found;						
				print "syntax error at $_ line $i, near 'lol'\n";
			}
		}
	}
	else {
		#~ print $str;
	}
	close $FH;
}
print "Found $found entries.\n";
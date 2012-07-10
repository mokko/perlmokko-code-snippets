#!perl -T

use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
	use_ok('Dedupe::DB') || print "Bail out!
";
}

BEGIN {
	use_ok('Dedupe::DB::File') || print "Bail out!
";
}

diag( "Testing Dedupe::DB $Dedupe::DB::VERSION, Perl $], $^X" );

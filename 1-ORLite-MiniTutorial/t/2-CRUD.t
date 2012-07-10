#!perl

use strict;
use warnings;
use Test::More tests => 12;
use Dedupe::DB;
use Scalar::Util qw(blessed);
use Data::Dumper qw(Dumper);

#
# PREP
#

my $store = new Dedupe::DB::File();
ok( blessed $store eq 'Dedupe::DB::File' );

my %file = (
	id    => 'path/to/file',
	mtime => 123,
	type  => 'file',
);


#
# Create
#

#in case stuff exists from last test run 
Dedupe::DB::File->truncate or die "Can't empty table";
#works the same
$store->truncate or die "Can't empty table";

ok ($store->Create(%file), 'valid Create');
ok (!$store->Create(%file), 'valid Create'); #id already exists
ok( !$store->Create(), 'invalid Create (empty param)' );
ok( !$store->Create( something => 'stupid' ), 'Create with invalid values' );
ok( $store->Create( something => 'stupid', id=>'/path' ), 'Create with stupid VALID values' );

#
# Read 
#

my $newFile=$store->Read ($file{id});
ok ($newFile->{id} eq $file{id} && $newFile->{mtime} eq $file{mtime} && $newFile->{type} eq $file{type}, 'read works');
ok (!$store->Read ('/new/path'), 'read non-existing id');

#print Dumper $newFile;

#
# Update
#
$file{mtime}=234;
ok ($store->Update (%file), 'valid update');
$newFile=$store->Read ($file{id});
ok ($newFile->{mtime} == 234, 'update works');
ok (!$store->Update (id=>'does/not/exist'), 'invalid update');


#
# Delete
#

ok ($store->Delete ($file{id}),'valid delete'); #doesn't die or croak on failure

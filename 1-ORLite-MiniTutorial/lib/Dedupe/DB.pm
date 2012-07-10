package Dedupe::DB;

use strict;
use warnings; 
use FindBin; #avoid in production
use File::Spec;
use constant DBFILE => File::Spec->catfile( $FindBin::Bin, 'dedupe.db' );

use ORLite {
 file         => DBFILE,
 user_version => 0,
 unicode => 1,
 create  => sub {
  my $dbh = shift;
  $dbh->do(
   'CREATE TABLE file (
                 id TEXT PRIMARY KEY NOT NULL,
                 action TEXT,
                 mtime INTEGER,
                 size INTEGER,
                 type TEXT, 
                 writable TEXT
                 )'
  );

  $dbh->do(
   'CREATE TABLE fingerprint (
    id TEXT NOT NULL,    
    created INTEGER NOT NULL,
    hash TEXT NOT NULL,
    type TEXT NOT NULL,
    PRIMARY KEY (id, type)
   )'
  );
 },
};
1;
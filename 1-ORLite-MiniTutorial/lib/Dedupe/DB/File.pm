package Dedupe::DB::File;

#ABSTRACT: CRUD Interface on top of ORLite object
use strict;
use warnings;
use Try::Tiny;
use SQL::Abstract;

#use Data::Dumper qw(Dumper);
sub verbose;

=head1 LET'S BE CRUD

Just to practice ORLite, let's implement an additional a low-level CRUD 
interface on top of what ORLite provides out of the box. To have two 
low-level db interfaces in parallel seems __not__ to be what you want 
to do in the real world. 

(In this context file stands for a description of a file.)

=head1 SYNOPSIS

	#this is the crud interface on top of the ORLite interface documented in 
	#separate pod file.

	use Dedupe::DB::File;
	my $file=new Dedupe::DB::File();
	$file->Create($file);
	$file->Read ($id);
	$file->Update ($file);
	$file->Delete ($file);

=cut

sub Create {
	my $self = shift or die "Need myself";
	my %file = @_ or return; 

	#let sqlite check if %file has a valid format
	#verbose "Create %file";

	my $ret = try {
		__PACKAGE__->create(%file);
	}
	catch {
		warn "ORLite error: $_";
		return;
	};
	return $ret;
}

sub Read {
	my $self = shift or die "Need myself";
	my $id   = shift or return;

	verbose "Reading $id";

	my $ret = try {
		__PACKAGE__->load($id);
	}
	catch {
		warn "ORLite error: $_";
		return;
	}; 
	return $ret;
}

sub Update {
	my $self = shift or die "Need myself";
	my %file = @_ or return; 

	my $abstract = SQL::Abstract->new;
	my ( $stmt, @bind ) = $abstract->update( 'file', \%file, {id=>$file{id}});
	print "sql:".$stmt.'|'."@bind"."\n";
	my $ret=Dedupe::DB->do( $stmt, undef, @bind );
	
	#if something should be updated and doesn't get updated I call this an error
	if ($ret eq '0E0') {
		return undef;
	}
	return $ret;
}


sub Delete {
	my $self = shift or die "Need myself";
	my $id   = shift or return;

	verbose "Delete $id";

	#ORLite's delete doesn't die if nothing to delete
	#nobody in their mind wants to check if something exists by deleting it
	#so that's fine.
	return 	__PACKAGE__->delete('where id = ?', $id);
}

#
#
#

sub verbose {
	my $msg = shift or return;
	print "$msg\n";
}

1;

#!/usr/local/bin/perl -w

# generator for astroconst header files
#  v2.3.8, 7 Jan 2003
#  Boyd Duffee (boyd@cs.keele.ac.uk)
#  v2.3,  3 June 2002
#  Jeremy Bailin (jbailin@as.arizona.edu)
#  Java patch 8 March 2000
#  Colin McNally (colin.mcnally.99n@shadnet.shad.ca
#
#  Takes the data file (usually astroconst.dat) and turns it into
#  ready-to-include header files in a Perl Module
#  Astro::Constants.pm
#
#  Documentation is in the file README. (if you're lucky)
#

# This has been horribly hacked into a minion to serve the evil Boyd
#  and his mighty Perl Modules -  8 Jan 2003

use warnings;
use strict;

my $factory_const_file = 'factory.dat';
my $custom_const_file = 'site_const.dat';
my (%const, @shortnames, @shortvarnames, @longnames);
my @functions = qw[ list_constants describe_constants precision pretty ];

# don't overwrite the site's custom file, but create it if it's not there
&generate_custom unless -e $custom_const_file;

foreach my $file ( $factory_const_file, $custom_const_file ) {
    grok($file);
}
@shortvarnames = map { "\$$_" } @shortnames;

foreach my $system ( qw( CGS MKS ) ) {
    open MODULE, "> $system.pm" 
	or die "Couldn't open $system.pm: $!\n";

    print MODULE <<"HEADER";
package Astro::Constants::$system;

require 5.004;
use strict;
use warnings;
use Astro::Constants;

require Exporter;
HEADER

# hopefully this allows perl 5.6.0 to use "our" variables and lets
# earlier versions of perl "use vars" instead
    my $our = 'our';
    if ( $] < 5.006 ) { 
	$our = '';
	print MODULE 
	    'use vars qw(@ISA %EXPORT_TAGS @EXPORT_OK @EXPORT $VERSION);', 
	    "\n";
    }

    print MODULE <<"HEADER";
$our \@ISA = qw(Exporter);

use vars qw(
    @shortvarnames
);

$our \%EXPORT_TAGS = ( 'short' => [ qw( 
    @shortvarnames 
    @functions ) ],
	 	      'long' => [ qw( 
    @longnames 
    @functions ) ] 
		   );

$our \@EXPORT_OK = qw( 
    @shortvarnames 
    @longnames 
    @functions );

$our \@EXPORT = qw( list_constants() );
$our \$VERSION = Astro::Constants::Version();

HEADER

my (@short_constants, @long_constants, @short_diml, @long_diml,
	%description, %rel_precision);

    foreach my $name (@shortnames) {

        if (exists $const{$name}{$system}) {

	    # prints the original short name with the scalar variable construct
	    push @short_constants,
		"\$$name = $const{$name}{$system};\t# $const{$name}{'desc'}";

	    $description{$name} = $const{$name}{'desc'};
	    $rel_precision{$name} = $const{$name}{'precision'};

      	    if (exists $const{$name}{'long'}) {

		# prints standard long name with the "use constant" construct
		push @long_constants,
		    "use constant $const{$name}{'long'} \t=> " .
		    "$const{$name}{$system};\t# $const{$name}{'desc'}";

	        $description{$const{$name}{'long'}} = $const{$name}{'desc'};
	        $rel_precision{$const{$name}{'long'}} = $const{$name}{'precision'};
	    }
        }
	else {
	    push @short_diml,
		"\$$name = $const{$name}{'dimless'};\t# $const{$name}{'desc'}";

	    $description{$name} = $const{$name}{'desc'};
	    $rel_precision{$name} = $const{$name}{'precision'};

      	    if (exists $const{$name}{'long'}) {

		# prints standard long name with the "use constant" construct
		push @long_diml,
		    "use constant $const{$name}{'long'} \t=> " .
		    "$const{$name}{'dimless'};\t# $const{$name}{'desc'}";

	        $description{$const{$name}{'long'}} = $const{$name}{'desc'};
	        $rel_precision{$const{$name}{'long'}} = $const{$name}{'precision'};
	    }
	}
    }

    my $old_list_separator = $";
    $" = "\n";
    print MODULE <<"CONSTANTS";
@short_constants

# Dimensionless constants start here
@short_diml

# These are the long names.
@long_constants

# Dimensionless constants with long names start here
@long_diml

CONSTANTS
    $" = $old_list_separator;

my @description_hash = map { "\t'$_' => q($description{$_}),\n" } 
	keys %description;
my @rel_precision_hash = map { "\t'$_' => '$rel_precision{$_}',\n" } 
	keys %rel_precision;

    print MODULE <<"FUNC";

# These are the functions that access a few properties of the constants

my \@shortnames = qw(
    @shortvarnames
);

my \@longnames = qw(
    @longnames
);

my \%description = (
@description_hash
);

my \%rel_precision = (
@rel_precision_hash
);

# should I return _two_ refs or one long list?
sub list_constants {
    return \\\@shortnames, \\\@longnames;
}

# These two routines require that the name of the constant be passed through
# enclosed by single quotes
# If called without an argument, the return a ref to the underlying hash

sub describe_constants {
    my \$name = shift;
    return \\\%description unless defined \$name;

    print "You probably need to enclose the constant \$name in single quotes\\n"
	if \$name =~ /^([+-]?)(?=\\d|\\.\\d)\\d*(\\.\\d*)?([Ee]([+-]?\\d+))?\$/;

    exists \$description{\$name} ? 
	return \$description{\$name} : return undef;
}

sub precision {
    my \$name = shift;
    return \\\%rel_precision unless defined \$name;

    print "You probably need to enclose the constant \$name in single quotes\\n"
	if \$name =~ /^([+-]?)(?=\\d|\\.\\d)\\d*(\\.\\d*)?([Ee]([+-]?\\d+))?\$/;

    exists \$rel_precision{\$name} ? 
	return \$rel_precision{\$name} : return undef;
}

sub pretty {
# would be nice if this could take a list
# OR even better, print out values only to their precision
# (What is the _right_ thing to do?)
    my \$value = shift;	
    my \$pretty = sprintf "%1.5e", \$value;
    return \$pretty;
}

1;
FUNC

close MODULE;
} # foreach: my $system


sub grok {
# opens up the filename in the argument and pushes all the data into a hash
# update the generate_custom sub if the file format changes
    my ($filename) = @_;
    open DATA, "$filename" or die "Couldn't open $filename for reading: $!\n";
    my ($sname, $lname, $desc, $cgs, $mks, $prec, $value, @fields, );

    while (<DATA>) {
	next if (/^\s*#/ || /^\s*$/);	# skip comments and blank lines
	chomp;

	@fields = split /\t/;
	if (scalar @fields == 6) {
            # different in CGS and MKS
	    ($sname, $lname, $desc, $cgs, $mks, $prec) = @fields;
	    if (exists $const{$sname} ) {
		warn "$sname ($lname) redeclared and will overwrite ",
			$const{$sname}{'CGS'}, " with $cgs\n";
	    }

	    $const{$sname} = { 'long' => $lname,
				'desc' => $desc, 
				'CGS' => $cgs,
				'MKS' => $mks,
				'precision' => $prec };
	}
	elsif (scalar @fields == 5) {
            # dimensionless, or at least the same in CGS and MKS
	    ($sname, $lname, $desc, $value, $prec) = @fields;
	    if (exists $const{$sname} ) {
		warn "$sname ($lname) redeclared and will overwrite ",
			$const{$sname}{'dimless'}, " with $value\n";
	    }

	    $const{$sname} = { 'long' => $lname,
				'desc' => $desc, 
				'dimless' => $value,
				'precision' => $prec };
	}
	else {
	    warn "Improper format on line $. of $filename starting with ",
		"$sname\nCorrect format is 5 or 6 fields separated by tabs\n";
	    next;
	}
    	push @shortnames, $sname;
    	push @longnames, $lname;
    }
    close DATA;
}

sub generate_custom {
    open(CUSTOM, "> $custom_const_file" )
	or die "Couldn't open $custom_const_file for writing: $!\n";
    print CUSTOM <<"EOF";
# (This needs a lot of cleaning up)
#
# This file, $custom_const_file, is where you add your site specific constants.
# A short name (first field) identical to an existing entry in the factory
# defaults will override the previous entry (because that's what you want
# it to do) and generate a warning during the installation (in case you
# didn't know that's what you're doing)
#
# Format is tab separated fields (whatever we settle on)
#
# Field 1 [short name for variable]	    same
# Field 2 [long name for variable]	    same
# Field 3 [description]	   		    same
# Field 4 [CGS value]			or [dimensionless value]
# Field 5 [MKS value]			   [precision]
# Field 6 [precision]			    no field
# 
# variable short name|long name|description|CGS value|MKS value|precision
#   or:
# variable short name|long name|description|dimensionless value|precision
# 
# for example
A_inch	INCH	some outdated unit of distance	2.54	0.0254	3e-3
A_gogl	GOOGOL	a very, very large number	1e100	0

EOF

    close CUSTOM;
}

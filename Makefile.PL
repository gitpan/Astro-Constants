#
# at least one of the .pm files uses our variables, so we
# need perl 5.6.0 or later
#

use strict;

my $modname = "Astro::Constants";

eval { require 5.004; } or die <<"EOD";
************************************************************************

 The $modname module requires perl version 5.0004 or higher 
 to implement the "use constant" pragma.

 It appears that your perl version is only $]

 Your choices are to upgrade your perl, use the astroconst.pl
 library supplied with the Astroconst package (web.astroconst.org),
 hack the makefile and the module or plead with the module maintainer.

************************************************************************
EOD

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> $modname,
    'VERSION_FROM'	=> 'Constants.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1,
    'AUTHOR'		=> 'Boyd Duffee (perl@cs.keele.ac.uk)',
    'ABSTRACT'		=> 'Physical and derived constants used in Astronomy',

    'PL_FILES'		=> { 'build.PL' => [ 'CGS.pm', 'MKS.pm' ] },
    'PM'		=> {
                            'Constants.pm' => '$(INST_LIBDIR)/Constants.pm',
    			    'CGS.pm' => '$(INST_LIBDIR)/Constants/CGS.pm',
    			    'MKS.pm' => '$(INST_LIBDIR)/Constants/MKS.pm'
                           },

# supresses man pages for CGS.pm and MKS.pm
    'MAN3PODS'	=> { 'Constants.pm' => '$(INST_MAN3DIR)/Astro::Constants.3',
		   },

    'clean'             => { 'FILES' => "CGS.pm MKS.pm" },
);



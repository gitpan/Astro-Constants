# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; }
END {print "Module didn't load.  First test failed\n" unless $loaded;}

use Astro::Constants::CGS qw[ :long ];
use Test::Simple tests => 13;
$loaded = 1;

######################### End of black magic.

ok( $loaded == 1, 'module loaded' );
ok( defined LIGHT_SPEED, 'long constants available' );
ok( LIGHT_SPEED == 2.997925e10, 'correct value for LIGHT_SPEED ' );
ok( LIGHT_SPEED == $Astro::Constants::CGS::A_c , 
	'short constants available');

$sch_rad = 2 * GRAVITATIONAL * SOLAR_MASS / LIGHT_SPEED ** 2 
    if (LIGHT_SPEED > 0);
ok( abs($sch_rad - 295356) < 200 , 
    "Schwarzschild radius of the Sun is calculated to be $sch_rad cm." );

ok( describe_constants('SOLAR_MASS') =~ /solar/, 
    'description of SOLAR_MASS is "' . 
    describe_constants('SOLAR_MASS') .  '"' );

ok( precision('SOLAR_MASS') =~ /\d+/ , 'numbers in precision' );

$d_sch_rad = precision('GRAVITATIONAL') + precision('SOLAR_MASS') 
	+ 2 * precision('LIGHT_SPEED');
$sch_rad_err = abs($sch_rad - 295356)/$sch_rad;
ok( $sch_rad_err < $d_sch_rad , 
    'correct precision for Schwarzschild radius' );

$pretty = pretty($sch_rad);
ok( $pretty =~ /\d\.\d{2,5}([Ee][+-]?\d+)?$/ , 
    "Does `$pretty' look nicer than `$sch_rad'?" );

($short_ref, $long_ref) = list_constants();
ok( ref $short_ref , 'reference to short constants' );
ok( ref $long_ref , 'reference to long constants' );
ok( scalar @{$short_ref} , 'list of short constants not empty' );
ok( scalar @{$long_ref} , 'list of long constants not empty' );
 

#!/usr/local/bin/perl -w

# convert.pl 
#	version 1.1,	13 Feb 2003
#
# This script converts Jeremy's old astroconst.dat file to the new
# format with long names and precision and calls it factory.dat
# for lack of a better name (avoiding conflits)

my $filename = 'factory.dat';

# v1.1 made the following changes:
# A_k	K_BOLTZMANN
# A_rhoc	CRITICAL_DENSITY
# A_arad	A_RADIATION
# A_alpha	ALPHA_FINE_STRUCTURE
#
# v1.1 made the following additions:
# A_yrsid	=> 'SIDEREAL_YEAR',
# A_day	=> 'DAY',
# A_daysid	=> 'SIDEREAL_DAY',

my %long_name = (
	A_c 	=> 'LIGHT_SPEED',
	A_k	=> 'K_BOLTZMANN',
	A_G	=> 'GRAVITATIONAL',
	A_me	=> 'ELECTRON_MASS',
	A_mp	=> 'PROTON_MASS',
	A_amu	=> 'ATOMIC_MASS_UNIT',
	A_eV	=> 'ELECTRON_VOLT',
	A_h	=> 'PLANCK',
	A_hbar	=> 'H_BAR',
	A_e	=> 'ELECTRON_CHARGE',
	A_mn	=> 'NEUTRON_MASS',
	A_mH	=> 'HYDROGEN_MASS',
	A_pc	=> 'PARSEC',
	A_msun	=> 'SOLAR_MASS',
	A_rsun	=> 'SOLAR_RADIUS',
	A_AU	=> 'ASTRONOMICAL_UNIT',
	A_ly	=> 'LIGHT_YEAR',
	A_Lsun	=> 'SOLAR_LUMINOSITY',
	A_mearth=> 'EARTH_MASS',
	A_rearth=> 'EARTH_RADIUS',
	A_AA	=> 'ANGSTROM',
	A_Jy	=> 'JANSKY',
	A_rhoc	=> 'CRITICAL_DENSITY',	#critical density /h^2
	A_sigma => 'STEFAN_BOLTZMANN',
	A_arad	=> 'A_RADIATION',	# radiation density constant
	A_sigmaT=> 'THOMSON_XSECTION',
	A_re	=> 'ELECTRON_RADIUS',
	A_a0	=> 'BOHR_RADIUS',
	A_Wien	=> 'WIEN',
	A_alpha	=> 'ALPHA_FINE_STRUCTURE',
	A_NA	=> 'AVOGADRO',
	A_yr	=> 'YEAR',	# is this the same as YEAR_TROPICAL?
	A_tH	=> 'HUBBLE_TIME',
	A_Tsun	=> 'SOLAR_TEMPERATURE',
	A_TCMB	=> 'CMB_TEMPERATURE',
	A_pi	=> 'PI',
	A_exp	=> 'EXP',
	A_dsun	=> 'SOLAR_DENSITY',
	A_dearth=> 'EARTH_DENSITY',
	A_gsun	=> 'SOLAR_GRAVITY',
	A_gearth=> 'EARTH_GRAVITY',
	A_Vsun	=> 'SOLAR_V_MAG',
	A_MVsun	=> 'SOLAR_V_ABS_MAG',
	A_Z0	=> 'VACUUM_IMPEDANCE',
	A_eps0	=> 'PERMITIV_FREE_SPACE',
	A_mu0	=> 'PERMEABL_FREE_SPACE',
	A_rmoon	=> 'LUNAR_RADIUS',
	A_mmoon	=> 'LUNAR_MASS',
	A_amoon	=> 'LUNAR_SM_AXIS',
	A_emoon	=> 'LUNAR_ECCENTRICITY',
	A_yrsid	=> 'SIDEREAL_YEAR',
	A_day	=> 'DAY',
	A_daysid	=> 'SIDEREAL_DAY',
);

# read in the database
# Format: variable<tab>description<tab>CGS value<tab>MKS value
#    or   variable<tab>description<tab>value
open DATFILE, 'astroconst.dat';
open NEWFILE, "> $filename";
dline:
while (<DATFILE>) {
    if (/^\s*#/ || /^\s*$/) {
	print NEWFILE;
	next;
    }

  chomp;
  ($vname,$desc,$cgs,$mks) = split /\t/;

  if ($mks) {
	print NEWFILE "$vname\t$long_name{$vname}\t$desc\t$cgs\t$mks\t",
	    get_precision($cgs), "\n";
  } 
  else {
	print NEWFILE "$vname\t$long_name{$vname}\t$desc\t$cgs\t",
	    get_precision($cgs), "\n";
  }
}
close DATFILE;
close NEWFILE;

print "The new file, $filename, is ready to go.  You will have to
check the precision values by hand.  The script is a bit dumb.\n";

sub get_precision {
    my $num = shift;
    ($big, $little) = $num =~ /^-?(\d+).?(\d*)e?-?\d*$/;
    unless (defined $big) {
	print "Can't compute precision for $num\n";
	return '?';
    }
    if (defined $little) {
	return '0.' . '0' x (length($little) + length($big) - 2) . '1';
    }
    return 1/$num;
}

package Astro::Constants;

$VERSION = "0.09";
sub Version { $VERSION; }

# the use of the constant pragma requires 5.004
require 5.004;

# defaulting to CGS units and importing long constant names
use Astro::Constants::CGS qw( :long ); 

1;

__END__

=head1 NAME

Astro::Constants - Physical constants for use in Astronomy

=head1 SYNOPSIS

  use Astro::Constants::CGS qw(:long);
  print "The Schwarzschild radius of the sun is ",
	2 * GRAVITATIONAL * SOLAR_MASS / LIGHT_SPEED ** 2, 
	" centimetres\n";


or

  use Astro::Constants::MKS qw(:short);
  print "The Schwarzschild radius of the sun is ",
	2 * $A_G * $A_msun / $A_c ** 2, 
	" metres\n";

=head1 DESCRIPTION

This module provides a large number of physical constants which are
useful to Astronomers. The module itself is essentially a wrapper
around the L<astroconst|"ASTROCONST"> package of Jeremy Balin.

It allows you to choose between constants in units of 
centimetres/grams/seconds
with B<Astro::Constants::CGS> and metres/kilograms/seconds with
B<Astro::Constants::MKS>.
It also allows you to select two different methods of refering to
the constants using the import tags C<:long> and C<:short>.  

The C<:short> tag refers to the constants in the
normal perl variable style, such as C<$A_G> for the gravitational
constant and C<$A_c> for the speed of light in a vaccuum.  The 
naming convention for the C<:short> constant is C<A_> prepended to
the symbol character.

The C<:long> tag refers to the constants  with longer descriptive
names in ALL_CAPS that have been created with the C<use constant>
pragma.  As in the example, C<GRAVITATIONAL> is the gravitational
constant and C<LIGHT_SPEED> is the speed of light.  This is a 
new addition to the Astroconst package and, at present, we are
following a naming convention of C<OBJECT_PROPERTY> and 
C<SYMBOL_SUBSCRIPT>.  Opinions on this matter will be listened
to and if we decline to agree, you can always change it yourself,
as described in L<"EXTENDING THE DATA SET">.

The C<:long> and the C<:short> tags import the same constants.
You may choose individual constants and even mix and match (I haven't
tested this) by importing them in the C<use> statement.

One of the problems with the long constants is that they are not interpolated
in double quotish situations because they are really inlined functions.

=head2 I<The Function List>

=over 4

=item list_constants()

returns 2 references to lists of constants, the first one for the short 
names, the second one for the long names.  (untested)

=item describe_constants()

returns the description of a constant.  remember to enclose the constant
in single quotes and remove the $ from the beginning of the short constants.
If no argument is given, it returns a reference to the underlying hash.

=item precision()

returns the relative precision to which that constant is know in the file. 
If no argument is given, it returns a reference to the underlying hash.

=item pretty()

runs a number through sprintf "%1.5e" to tidy up values

=back

=head2 I<The Constants List>

Now if I list all the constants here, this becomes a I<very> long 
document and the information is already available in the F<*.dat>
files and via the list_constants() function.

=head1 EXTENDING THE DATA SET

If you want to add in your own constants or override the factory defaults,
run make, edit the F<site_const.dat> file and then run make again.  
If you have a pre-existing F<site_const.dat> file, drop it in place
before running make.


=head1 EXPORT

The only function automatically exported is list_constants().

right now Astro::Constants defaults to S<Astro::Constants::CGS qw(:long)>
(is that a good thing? - moot point 'cuz it doesn't work.)

=head1 ASTROCONST  X<ASTROCONST>

(Gleaned from the Astroconst home page - 
L<http://web.astroconst.org|http://web.astroconst.org> )

Astroconst is a set of header files in various languages (currently C,
Fortran, Perl, Java, IDL and Gnuplot) that provide a variety of useful
astrophysical constants without constantly needing to look them up.

The generation of the header files from one data file is automated, so you
can add new constants to the data file and generate new header files in all
the appropriate languages without needing to fiddle with each header file
individually. 

This package was created and is maintained by Jeremy Bailin.  It's license 
states that it I<is completely free, both as in speech and as in beer>.

=head1 DISCLAIMER

Since this package uses the values provided by the astroconst package we
include the disclaimer from that package here:

The Astroconst values have been gleaned from a variety of sources,
and have quite different precisions depending both on the known 
precision of the value in question, and in some cases on the 
precision of the source I found it from. These values are not 
guaranteed to be correct. Astroconst is not certified for any use 
whatsoever. If your rocket crashes because the precision of the
lunar orbital eccentricity isn't high enough, that's too bad.

=head1 COMPATIBILITY

(Post test results here)

Astro::Constants has been tested under:

B<Perl>	     B<Platform>		B<Results>

5.6.0	Solaris 8		Works for me (BD)



=head1 BUGS

The Author needs to check the documentation yet again.

I haven't tested the list_constants() function.  I'm not really bothered.
Let me know if you use it.

"use Astro::Constants" doesn't work.  I'd like it to provide a default
behaviour, but for now you need to be explicit and 
"use Astro::Constants::CGS qw( :long )" instead.

=head1 ACKNOWLEDGEMENTS

Jeremy Balin, for writing the astroconst package and helping
test and develop this module.

Doug Burke, for giving me the idea to write this module in the 
first place, tidying up Makefile.PL, testing and improving the 
documentation.

-> Put Jeremy's constant references here <-

=head1 AUTHOR

Boyd Duffee, perl@cs.keele.ac.uk

Copyright 2003, Boyd Duffee

All rights reserved. There is no warranty.
This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), L<Doug Burke's Astro::Cosmology module|Astro::Cosmology>, 
L<PerlDL|PDL>, 
L<the National Institute of Standards and Technology|http://www.nist.gov>.

=head1 AVAILABILITY

try the astroconst web site currently at 
	L<U of Arizona|http://clavelina.as.arizona.edu/astroconst/>
which has been relocated to
	L<Astroconst.org|http://web.astroconst.org/>

there I<might> be something at
	L<astro.keele.ac.uk|http://www.astro.keele.ac.uk/~bjd/perl/>

=cut


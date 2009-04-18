use strict;
use warnings;

use Color::Theme;
use JSON;
use Test::More 'no_plan';

ok(1);

my %pobox_colors = (
  background => [ 0xEE, 0xEE, 0xEE ],

  plainText  => 'black',
  errorText  => 'poboxRedDark',
  brightText => 'poboxBlueLight',

  highlight  => 'poboxBlue',
  lowlight   => [ 0x33, 0x33, 0x33 ],

  linkText   => 'poboxBlueDark',

  black      => [ 0x00, 0x00, 0x00 ],
  white      => [ 0xFF, 0xFF, 0xFF ],

  poboxBlue      => [ 0x0A, 0x5E, 0xFF ],
  poboxBlueDark  => [ 0x04, 0x3F, 0xA6 ],
  poboxBlueLight => [ 0xC8, 0xDF, 0xFE ],
  poboxRedDark   => [ 0xA4, 0x00, 0x05 ],
);

my %listbox_colors = (
  background => [ 0xEE, 0xEE, 0xEE ],

  plainText  => 'black',
  errorText  => 'listboxRedDark',
  brightText => 'listboxGreenLight',

  highlight  => 'listboxGreen',
  lowlight   => [ 0x33, 0x33, 0x33 ],

  linkText   => 'listboxGreenDark',

  black      => [ 0x00, 0x00, 0x00 ],
  white      => [ 0xFF, 0xFF, 0xFF ],

  listboxGreen      => [ 0x66, 0x99, 0x00 ],
  listboxGreenDark  => [ 0x3E, 0x51, 0x13 ],
  listboxGreenLight => [ 0xB9, 0xDB, 0x5D ],
  listboxRedDark    => [ 0xA4, 0x00, 0x05 ],
);

my @required = qw(
  background plainText errorText brightText highlight lowlight linkText
);

my $theme = Color::Theme->new({ required_colors => \@required });

my $pobox_palette = $theme->make_palette(\%pobox_colors);

my $listbox_palette = $theme->make_minimal_palette(\%listbox_colors);

diag(JSON->new->encode( $pobox_palette ));

diag(JSON->new->encode( $listbox_palette ));

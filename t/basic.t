use strict;
use warnings;

use Color::Palette;
use Color::Palette::Schema;
use Test::More tests => 7;

my $pal_schema = Color::Palette::Schema->new({
  required_colors => [ qw(
    background plainText errorText brightText highlight lowlight linkText
  ) ]
});

my $bad_pal = Color::Palette->new({ colors => { blue => '#00f' } });
eval { $pal_schema->check($bad_pal); };
like($@, qr/no color named/, "bad palette rejected by schema");

my $pobox_palette   = Color::Palette->new({
  colors => {
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
  },
});

my $listbox_palette = Color::Palette->new({
  colors => {
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
  },
});

my $opto_pobox = $pobox_palette->optimize_for($pal_schema);

isa_ok(
  $pobox_palette->color('poboxBlue'),
  'Color::Palette::Color',
);

eval { $opto_pobox->color('poboxBlue') };
like($@, qr/no color named poboxBlue/, "poboxBlue is removed by optimize");

isa_ok(
  $opto_pobox->color('highlight'),
  'Color::Palette::Color',
);

is(
  $pobox_palette->color('poboxBlue')->hex_triple,
  $opto_pobox->color('highlight')->hex_triple,
  "the optimized highlight value is really poboxBlue",
);

my @orig_names = $pobox_palette->color_names;
my @opto_names = $opto_pobox->color_names;
is(@orig_names, 13, "we defined 13 colors in the pobox palette");
is(@opto_names,  7, "...but we strip down to 7 when optimizing");

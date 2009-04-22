use strict;
use warnings;

use Color::Theme;
use HTML::Entities;
use JSON;

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

my $pobox_palette   = $theme->make_minimal_palette(\%pobox_colors);
my $listbox_palette = $theme->make_minimal_palette(\%listbox_colors);

my $pcs = JSON->new->encode($pobox_palette);
my $lcs = JSON->new->encode($listbox_palette);

my $HTML = <<"HTML";
<html>
<head>
  <title>Test Page</title>
  <script src='http://rjbs.manxome.org/js/jquery.js'></script>
</head>

<script>
var palette = {
  pobox  : $pcs,
  listbox: $lcs,
};

function makeRGBA(arr) {
  var str = 'rgb(' + arr[0] + ', ' + arr[1] + ', ' + arr[2] + ')';

  return str;
}

function applyStyle(which) {
  var pal = palette[ which ];
  var rgb_str;
  
  \$("body").css({ backgroundColor: makeRGBA(pal.background) });

  \$("h1").css({ color: makeRGBA(pal.highlight) });

  \$(".error").css({ color: makeRGBA(pal.errorText)});

  \$("blockquote").css({
    color: makeRGBA(pal.highlight),
    backgroundColor: makeRGBA(pal.lowlight)
  });

  \$("pre").css({
    border: "medium dashed " + makeRGBA(pal.linkText)
  });
}
</script>

<body>
  <h1>This is a Demo Page</h1>

  <div class='error'>error text</div>
  <blockquote>
    This is some demo text.
  </blockquote>

  <p>
    ...and here is some boring normal text.
  </p>

  <button onClick="applyStyle('pobox')">Pobox</button>
  <button onClick="applyStyle('listbox')">Listbox</button>

<pre>
PROGRAM_SOURCE
</pre>
</body>
</html>
HTML

my $source = do {
  seek *DATA, 0, 0;
  local $/;
  <DATA>;
};

$source = encode_entities($source);
$HTML =~ s/PROGRAM_SOURCE/$source/;

print $HTML;
__DATA__

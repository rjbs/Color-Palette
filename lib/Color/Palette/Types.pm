package Color::Palette::Types;
use strict;
use warnings;

use Color::Palette::Color;

use MooseX::Types -declare => [ qw(
  Color Palette
  ColorDict
  RecursiveColorDict
  HexColorStr
  ArrayRGB
) ];

use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);

class_type Color,   { class => 'Color::Palette::Color' };
class_type Palette, { class => 'Color::Palette' };

subtype HexColorStr, as Str, where { /\A#?(?:[0-9a-f]{3}|[0-9a-f]{6})\z/i };

subtype ArrayRGB, as ArrayRef[Int],
  where { @$_ == 3 and 3 == (grep { $_ >= 0 and $_ < 256 } @$_) };

coerce Color, from ArrayRGB, via {
  Color::Palette::Color->new({
    red   => $_->[0],
    green => $_->[1],
    blue  => $_->[2],
  })
};

coerce Color, from HexColorStr, via {
  my @rgb = /\A#?([0-9a-f]{1,2})([0-9a-f]{1,2})([0-9a-f]{1,2})\z/;
  Color::Palette::Color->new({
    red   => hex($rgb[1]),
    green => hex($rgb[2]),
    blue  => hex($rgb[3]),
  });
};

subtype ColorDict, as HashRef[ Color ];
coerce  ColorDict, from HashRef, via {
  my $input = $_;
  return { map {; $_ => to_Color($input->{$_}) } keys %$input };
};

subtype RecursiveColorDict, as HashRef[ Color | Str ];
coerce  RecursiveColorDict, from HashRef, via {
  my $input = $_;
  my %output;
  for my $name (keys %$input) {
    my $val = $input->{ $name };
    $output{ $name } = $val, next unless ref $val or is_HexColorStr($val);
    $output{ $name } = to_Color($val);
  }

  return \%output
};

1;

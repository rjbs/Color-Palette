package Color::Palette::Schema;
use Moose;
# ABSTRACT: requirements for a palette

use Color::Palette;

has required_colors => (
  is  => 'ro',
  isa => 'ArrayRef[Str]',
  required => 1,
);

sub check {
  my ($self, $palette) = @_;

  # ->color will throw an exception on unknown colors, doing our job for us.
  # -- rjbs, 2009-05-19
  $palette->color($_) for @{ $self->required_colors };
}

1;

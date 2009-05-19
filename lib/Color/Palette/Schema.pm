package Color::Palette::Schema;
use Moose;
# ABSTRACT: requirements for a palette

use Color::Palette;
use Color::Palette::Types qw(ColorName);
use MooseX::Types::Moose qw(ArrayRef);

=head1 DESCRIPTION

Most of this is documented in L<Color::Palette>.  Below is just a bit more
documentation.

=attr required_colors

This is an arrayref of color names that must be present in any palette checked
against this schema.

=cut

has required_colors => (
  is  => 'ro',
  isa => ArrayRef[ ColorName ],
  required => 1,
);

=method check

  $schema->check($palette);

This method will throw an exception if the given palette doesn't meet the
requirements of the schema.

=cut

sub check {
  my ($self, $palette) = @_;

  # ->color will throw an exception on unknown colors, doing our job for us.
  # -- rjbs, 2009-05-19
  $palette->color($_) for @{ $self->required_colors };
}

1;

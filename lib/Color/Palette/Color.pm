package Color::Palette::Color;
use Moose;
# ABSTRACT: a color in RGB space

use Color::Palette::Types qw(Byte);

=head1 DESCRIPTION

This is just a color.  Nothing much to see here.

=attr red

=attr green

=attr blue

Each of these is an integer from 0 to 255, inclusive.

=cut

has [ qw(red green blue) ] => (is => 'ro', isa => Byte, required => 1);

=method hex_triple

This method returns a string like C<#08a2ef>.

=cut

sub hex_triple {
  my ($self) = @_;

  sprintf '#%02x%02x%02x', $self->rgb;
}

=method rgb

This method returns the red, green, and blue components.  In list context, it
returns the list.  In scalar context, it returns an arrayref.

=cut

sub rgb {
  my ($self) = @_;
  my @rgb = map {; $self->$_ } qw(red green blue);
  return wantarray ? @rgb : \@rgb;
}

no Moose;
1;

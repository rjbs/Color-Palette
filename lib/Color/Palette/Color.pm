package Color::Palette::Color;
use Moose;
# ABSTRACT: a color in RGB space

has [ qw(red green blue) ] => (is => 'ro', isa => 'Int', required => 1);

sub hex_triple {
  my ($self) = @_;

  sprintf '#%02x%02x%02x', $self->rgb;
}

sub rgb {
  my ($self) = @_;
  my @rgb = map {; $self->$_ } qw(red green blue);
  return wantarray ? @rgb : \@rgb;
}

no Moose;
1;

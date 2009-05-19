package Color::Palette::Color;
use Moose;

has [ qw(red green blue) ] => (is => 'ro', isa => 'Int', required => 1);

sub hex_triple {
  my ($self) = $_;

  sprintf '#%02x%02x%02x', map {; $self->$_ } qw(red green blue);
}

no Moose;
1;

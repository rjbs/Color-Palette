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
  
  for my $name (@{ $self->required_colors }) {
    confess("missing required color $name") unless $palette->has_color($name);
  };
}

1;

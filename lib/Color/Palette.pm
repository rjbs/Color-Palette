package Color::Palette;
use Moose;
# ABSTRACT: a set of named colors

use MooseX::Types::Moose qw(Str HashRef ArrayRef);
use Color::Palette::Types qw(RecursiveColorDict ColorDict Color);

has colors => (
  is   => 'ro',
  isa  => RecursiveColorDict,
  coerce   => 1,
  required => 1,
);

has resolved_colors => (
  is   => 'ro',
  isa  => ColorDict,
  lazy => 1,
  coerce   => 1,
  required => 1,
  builder  => '_build_resolved_colors',
);

sub _build_resolved_colors {
  my ($self) = @_;

  my $input = $self->colors;

  my %output;

  for my $key (keys %$input) {
    my $value = $input->{ $key };
    next unless ref $value;

    $output{ $key } = $value;
  }

  for my $key (keys %$input) {
    my $value = $input->{ $key };
    next if ref $value;

    my %seen;
    my $curr = $key;
    REDIR: while (1) {
      Carp::confess "$key refers to missing color $curr"
        unless exists $input->{$curr};

      if ($output{ $curr }) {
        $output{ $key } = $output{ $curr };
        last REDIR;
      }

      $curr = $input->{ $curr };
      Carp::confess "looping at $curr" if $seen{ $curr }++;
    }
  }

  return \%output;
}

sub color {
  my ($self, $name) = @_;
  confess("no color named $name")
    unless my $color = $self->resolved_colors->{ $name };

  return $color;
}

sub color_names {
  my ($self) = @_;
  keys %{ $self->colors };
}

sub hex_triples {
  my ($self) = @_;
  my $output = {};
  $output->{ $_ } = $self->color($_)->hex_triple for $self->color_names;
  return $output;
}

sub optimize_for {
  my ($self, $checker) = @_;

  my $required_colors = $checker->required_colors;

  my %new_palette;
  for my $name (@{ $checker->required_colors }) {
    $new_palette{ $name } = $self->color($name);
  }

  (ref $self)->new({
    colors => \%new_palette,
  });
}

1;

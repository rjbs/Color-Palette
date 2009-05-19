package Color::Palette;
use Moose;

use MooseX::Types::Moose qw(Str HashRef ArrayRef);
use Color::Palette::Types qw(RecursiveColorDict ColorDict Color);

# has _colors => hashref
# sub color_names
# sub rgb('name')
has _colors => (
  is   => 'ro',
  isa  => RecursiveColorDict,
  lazy => 1,
  coerce   => 1,
  default  => undef,
  required => 1,
);

has _optimized_colors => (
  is   => 'ro',
  isa  => ColorDict,
  required => 1,
  builder  => '_build_optimized_colors',
);

sub _build_optimized_colors {
  my ($self) = @_;

  my $input = $self->_colors;

  my %output;

  for my $key (keys %$input) {
    my $value = $input->{ $key };
    next unless ref $value;

    $output{ $key } = [ @$value ];
    $output{ $key }[3] = 0 if @{ $output{ $key } } == 3;
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

sub color_names {
  my ($self) = @_;
  keys %{ $self->_colors };
}

sub optimize_for {
  my ($self, $checker) = @_;

  my $required_colors = $checker->required_colors;

  my %new_palette;
  for my $name (@{ $checker->required_colors }) {
    $new_palette{ $name } = $self->rgba;
  }

  (ref $self)->new({
    colors => \%new_palette,
  });
}

1;

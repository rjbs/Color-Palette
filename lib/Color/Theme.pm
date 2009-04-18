package Color::Theme;
use Moose;

has required_colors => (
  is       => 'ro',
  isa      => 'ArrayRef[Str]',
  default  => sub { [] },
  init_arg => 'required',
);

sub make_palette {
  my ($self, $input) = @_;

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
      die "$key refers to missing color $curr" unless exists $input->{$curr};
      
      if ($output{ $curr }) {
        $output{ $key } = $output{ $curr };
        last REDIR;
      }

      $curr = $input->{ $curr };
      die "looping at $curr" if $seen{ $curr }++;
    }
  }

  return \%output;
}

sub make_minimal_palette {
  my ($self, $input) = @_;

  my $palette = $self->make_palette($input);

  my %return;
  for my $name (@{ $self->required_colors }) {
    $return{ $name } = $palette->{ $name };
  }

  return \%return;
}

no Moose;
1;

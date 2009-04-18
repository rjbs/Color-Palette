package Color::Theme;
use base 'Class::Accessor';

use Carp ();

__PACKAGE__->mk_ro_accessors(qw(required_colors));

sub new {
  my ($class, @rest) = @_;

  my $self = $class->SUPER::new(@rest);
}

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

sub make_minimal_palette {
  my ($self, $input) = @_;

  my $palette = $self->make_palette($input);

  my %return;
  for my $name (@{ $self->required_colors }) {
    $return{ $name } = $palette->{ $name };
  }

  return \%return;
}

1;

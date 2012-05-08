package Lexicon::Edit;
use Moose;
use MooseX::StrictConstructor;

# a turn is:
#   timestamp
#   player_name
#   pages created
#   pages implied

has player_name => (is => 'ro', isa => 'Str', required => 1);

has is_typo_fix => (
  is => 'ro',
  isa => 'Bool',
  default => 0,
);

has timestamp => (
  is  => 'ro',
  isa => 'Int',
  default  => sub { time }
);

has page_contents => (
  isa => 'HashRef',
  traits   => [ 'Hash' ],
  handles  => { page_contents => 'elements' },
  required => 1
);

for my $verb (qw(created implied)) {
  has "pages_$verb" => (
    isa  => 'ArrayRef',
    lazy => 1,
    builder  => "compute_pages_$verb",
    traits   => [ 'Array' ],
    handles  => { "pages_$verb" => 'elements' },
    required => 1,
  );
}

1;

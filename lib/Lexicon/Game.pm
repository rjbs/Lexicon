package Lexicon::Game;
use Moose;
use MooseX::StrictConstructor;

use Lexicon::Edit;
use Lexicon::X;
use List::AllUtils qw(first);

has storage => (
  is => 'ro',
  required => 1,
  handles  => [ 'last_turn' ],
);

has player_names => (
  isa => 'ArrayRef',
  traits  => [ 'Array' ],
  handles => {
    player_names => 'elements',
  },
);

sub next_turn_player_name {
  my ($self) = @_;
  my $last_turn = $self->storage->last_turn;
  return( ($self->player_names)[0] ) unless $last_turn;

  my @player_names = $self->player_names;

  my $n = first { $player_names[$_] eq $last_turn->player_name }
          (0 .. $#player_names);

  return $player_names[ ($n+1)  %  @player_names ];
}

sub record_edit {
  my ($self, $edit) = @_;

  if ($edit->is_typo_fix) {
    $self->_assert_typo_fix_ok($edit);
    $self->storage->save_edit($edit);
  }

  Lexicon::X->throw("it isn't the editor's turn")
    unless $edit->player_name eq $self->next_turn_player_name;

  $self->_assert_creations_ok( $edit );
  $self->_assert_implications_ok( $edit );

  $self->storage->save_edit($edit);
}

sub _assert_creations_ok { 1 }
sub _assert_implications_ok { 1 }

1;

use strict;
use warnings;
use Test::Fatal;
use Test::More;

use lib 't/lib';

use Lexicon::Edit;
use Lexicon::Game;
use Lexicon::TestStorage;

my $game = Lexicon::Game->new({
  storage      => Lexicon::TestStorage->new,
  player_names => [ qw(arjuna krsna bob) ],
});

{
  my $edit = Lexicon::Edit->new({
    player_name   => 'krsna',
    page_contents => {
      'The Assault on Zingo' => "Many [Bothans]() died.\n",
      'America Eats Pie'     => "...mostly pumpkin and apple.\n",
    },
  });

  my $e = exception { $game->record_edit($edit); };
  isa_ok($e, 'Lexicon::X');
  is($e->message, "it isn't the editor's turn", "out of order exception");

  is($game->last_turn, undef, "no turns recorded");
}

{
  my $edit = Lexicon::Edit->new({
    player_name   => 'arjuna',
    page_contents => {
      'The Assault on Zingo' => "Many [Bothans]() died.\n",
      'America Eats Pie'     => "...mostly pumpkin and apple.\n",
    },
  });

  my $e = exception { $game->record_edit($edit); };
  is($e, undef, "we recorded this play correctly");

  isnt($game->last_turn, undef, "a turn recorded");
}

done_testing;

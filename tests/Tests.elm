module Tests exposing (..)

import Blackjack exposing (..)
import Expect
import Test exposing (Test, describe, test)
import Json.Decode as JD exposing ((:=))
import Json.Encode as JE
import String
import Test.Runner.Html

aceSpades = newCard Ace Spades
nineDiamonds = newCard Nine Diamonds
nineSpades = newCard Nine Spades
aceDiamonds = newCard Ace Diamonds
tenHearts = newCard Ten Hearts
queenClubs = newCard Queen Clubs

aS9D = newHand |> addCardToHand aceSpades |> addCardToHand nineDiamonds
aS9S = newHand |> addCardToHand aceSpades |> addCardToHand nineSpades
aSaD = newHand |> addCardToHand aceSpades |> addCardToHand aceDiamonds
aStH = newHand |> addCardToHand aceSpades |> addCardToHand tenHearts
tHqC = newHand |> addCardToHand tenHearts |> addCardToHand queenClubs
tDfCfHaS =
  newHand |> addCardToHand (newCard Two Diamonds) |> addCardToHand (newCard Four Clubs)
    |> addCardToHand (newCard Four Hearts) |> addCardToHand aceSpades
tHqCfH =
  newHand |> addCardToHand tenHearts |> addCardToHand queenClubs
    |> addCardToHand (newCard Four Hearts)
tHqCfHaD = tHqCfH |> addCardToHand aceDiamonds


splitTests : Test
splitTests =
  describe "isSplittable"
    [ test "Two different cards" <| \() -> isSplittable aS9D |> Expect.equal False
    , test "Different cards, same suit" <| \() -> isSplittable aS9S |> Expect.equal False
    , test "Same cards" <| \() -> isSplittable aSaD |> Expect.equal True
    , test "Two face cards" <| \() -> isSplittable tHqC |> Expect.equal True
    ]


hasAceTests : Test
hasAceTests =
  describe "hasAce"
    [ test "Two cards, one ace" <| \() -> hasAce aS9D |> Expect.equal True
    , test "No ace" <| \() -> hasAce tHqC |> Expect.equal False
    , test "Two aces" <| \() -> hasAce aSaD |> Expect.equal True
    , test "One ace, four cards" <| \() -> hasAce tDfCfHaS |> Expect.equal True
    ]


isBlackjackTests : Test
isBlackjackTests =
  describe "isBlackjack"
    [ test "Two aces" <| \() -> isBlackjack aSaD |> Expect.equal False
    , test "No aces" <| \() -> isBlackjack tHqC |> Expect.equal False
    , test "Ace and face card" <| \() -> isBlackjack aStH |> Expect.equal True
    , test "Ace and under card" <| \() -> isBlackjack aS9D |> Expect.equal False
    ]


bestScoreTests : Test
bestScoreTests =
  describe "bestScore"
    [ test "Ace and nine" <| \() -> bestScore aS9D |> Expect.equal 20
    , test "Ace and ace" <| \() -> bestScore aSaD |> Expect.equal 12
    , test "Two, four, four, and ace" <| \() -> bestScore tDfCfHaS |> Expect.equal 21
    , test "Ten and queen" <| \() -> bestScore tHqC |> Expect.equal 20
    , test "Bust w/o ace" <| \() -> bestScore tHqCfH |> Expect.equal 0
    , test "Bust with ace" <| \() -> bestScore tHqCfHaD |> Expect.equal 0
    ]


all : Test
all =
  describe "Blackjack Module"
    [ splitTests
    , hasAceTests
    , isBlackjackTests
    , bestScoreTests
    ]


main : Program Never
main =
  Test.Runner.Html.run all

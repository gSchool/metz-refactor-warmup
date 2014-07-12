class Game < ActiveRecord::Base
  serialize :last_roll, Array

  def first_roll
    self.available_dice = 6
    self.last_roll = roll_dice
  end

  def roll_again(scoring_dice)
    self.available_dice -= scoring_dice.length
    self.available_dice = 6 if self.available_dice == 0
    self.current_score += score(scoring_dice)
    self.last_roll = roll_dice
    self.save
  end

  def stay(scoring_dice)
    self.total_score ||= 0
    self.current_score ||=0
    self.current_score += score(scoring_dice)
    self.total_score += self.current_score
    self.current_score = 0
    self.available_dice = 6
    self.save
  end

  def roll_dice
    dice = { 1 => '⚀',
             2 => '⚁',
             3 => '⚂',
             4 => '⚃',
             5 => '⚄',
             6 => '⚅',
    }
    (1..self.available_dice).map { rand(1..6) }.sort.map {|face| [face, dice[face]] }
  end

  private

  def score(scoring_dice)
    tally_score = 0
    tally_score += scoring_dice.count('1') * 100 if scoring_dice.count('1') > 0 && scoring_dice.count('1') < 3
    tally_score += scoring_dice.count('5') * 50 if scoring_dice.count('5') > 0 && scoring_dice.count('5') < 3

    tally_score
  end
end

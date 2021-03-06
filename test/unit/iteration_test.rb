require 'test_helper'

class IterationTest < ActiveSupport::TestCase

  should validate_presence_of :name
  should validate_presence_of :velocity
  should validate_numericality_of :velocity

  should have_many :stories
  should have_many(:geeks).through(:participations)
  should have_many :participations
  should belong_to :release

  context "An Iterations's burndown data method" do

    context "for incomplete stories" do

      setup do
        @iteration = Iteration.make
        Story.make(:points => 5, :iteration => @iteration)
        Story.make(:points => 2, :iteration => @iteration)
      end

      should "return an empty array" do
        assert_equal @iteration.burndown_data, []
      end
    end

    context "for completed and qa stories" do
      setup do
        @iteration = Iteration.make
        Story.make(:points => 3, :iteration => @iteration, :status => "new")
        Story.make(:points => 2, :iteration => @iteration, :status => "in_progress")
        Story.make(:points => 5, :iteration => @iteration, :status => "quality_assurance")
        Story.make(:points => 5, :iteration => @iteration, :status => "completed")
        Story.make(:points => 2, :iteration => @iteration, :status => "completed")
      end

      should "return a points value for qa stories" do
        assert_equal 5, @iteration.burndown_data("quality_assurance").first.points
      end
      should "return a points value for completed stories" do
        assert_equal 7, @iteration.burndown_data("completed").first.points
      end
    end
  end

end


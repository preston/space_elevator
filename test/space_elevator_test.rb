require 'test_helper'

class SpaceElevatorTest < Minitest::Test
    def test_that_it_has_a_version_number
        refute_nil ::SpaceElevator::VERSION
    end

    def test_client_exists_i_guess
        client = SpaceElevator::Client.new('ws://example.com')
        refute_nil client
    end
end

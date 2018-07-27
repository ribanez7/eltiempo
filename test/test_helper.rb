$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "eltiempo"

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new]
# Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

module MiniTest
  module Assertions
    def refute_raises(*exp)
      _msg = "#{exp.pop}.\n" if String === exp.last

      begin
        yield
      rescue MiniTest::Skip => e
        return e if exp.include? MiniTest::Skip
        raise e
      rescue Exception => e
        exp = exp.first if exp.size == 1
        flunk "unexpected exception raised: #{e}"
      end
    end
  end
  module Expectations
    infect_an_assertion :refute_raises, :wont_raise
  end
end

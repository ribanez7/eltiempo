module Eltiempo
  Error = Class.new(StandardError)
  ConfigurationError = Class.new(Error)
  SerializationError = Class.new(Error)

  class PlaceMissingError < StandardError
    MSG = <<~ERR.freeze
      Place needed, please execute the place() method
      with a municipality from Barcelona province
    ERR
    def initialize(msg = MSG)
      super
    end
  end

  class PlaceNotFoundError < StandardError
    MSG = <<~ERR.freeze
      Place not found on the api. Please, check name variations
    ERR
    def initialize(msg = MSG)
      super
    end
  end
end

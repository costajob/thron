require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Score
      def self.mappings
        @mappings ||= { 
          avarage: Attribute::new(name: 'scoreAverage', type: Attribute::INT),
          votes_count: Attribute::new(name: 'numberOfVotes', type: Attribute::INT)
        }
      end
      include Mappable
    end
  end
end

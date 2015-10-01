module Thron
  module Inflector
    PLURALS   = %w[anomalies]
    SINGULARS = %w[anomaly]

    refine String do
      def singularize
        if idx = Thron::Inflector::PLURALS.index(self)
          Thron::Inflector::SINGULARS.fetch(idx)
        else
          self[0...-1]
        end
      end

      def pluralize
        if idx = Thron::Inflector::SINGULARS.index(self)
          Thron::Inflector::PLURALS.fetch(idx) 
        else
          "#{self}s"
        end
      end

      def snakecase
        gsub(/(.)([A-Z])/,'\1_\2').downcase
      end

      def camelize
        return self if self !~ /_/ && self =~ /[A-Z]+.*/
        split('_').map{|e| e.capitalize}.join
      end
    end
  end
end

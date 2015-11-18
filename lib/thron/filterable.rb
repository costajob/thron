module Thron
  module Filterable
    module ClassMethods
      def before(*names)
        names.each do |name|
          m = instance_method(name)
          define_method(name) do |*args, &block|  
            yield(self)
            m.bind(self).(*args, &block)
          end
        end
      end
    end
    
    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end

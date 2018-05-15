
require_relative './factory_instance_methods_initializer'

# Factory class have Struct-like behavior
#
class Factory
  include Enumerable

  def self.new(*attributes)
    class_name = attributes.shift  if attributes[0].is_a? String

    struct_class = Class.new(self) do
      include FactoryInstanceMethodsInitializer.new(*attributes)
    end
    # struct_class is a subclass of Factory , so we had to redefine method :new
    struct_class.define_singleton_method(:new, Object.method(:new))

    class_name ? const_set(class_name.to_s, struct_class) : struct_class
  end
end

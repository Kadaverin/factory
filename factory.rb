#
# Factory class have Struct-like behavior
#
class Factory
  include Enumerable

  def self.new(*attributes, &init_block)
    class_name = attributes.shift if (attributes.first.is_a? String) &&
                                     attributes.first.match(/[A-Z]/)

    define_method(:to_a) { attributes.map { |attr| send(attr) } }

    define_method(:to_h) { attributes.zip(values).to_h }

    define_method(:length) { attributes.length }

    define_method(:members) { attributes }

    define_method :[] do |index|
      case index.class.name

      when 'Integer'
        raise IndexError unless attributes[index]
        send(attributes[index].to_s)

      when 'String', 'Symbol'
        raise NameError unless attributes.include? index
        send(index)
      else raise ArgumentError
      end
    end

    define_method :[]= do |key, value|
      case key.class.name

      when 'String', 'Symbol'
        raise NameError unless attributes.include? key
        send("#{key}=", value)

      when 'Integer'
        raise IndexError unless attributes[key]
        send("#{attributes[key]}=", value)
      end
    end

    alias_method :to_s, :inspect
    alias_method :size, :length
    alias_method :values, :to_a

    struct_class = Class.new(self) do
      attr_accessor(*attributes)
      class_eval(&init_block) if init_block

      define_method :initialize do |*values|
        values.each_with_index { |val, i| send("#{attributes[i]}=", val) }
      end
    end

    # struct_class is a subclass of Factory , so we had to redefine method :new
    struct_class.define_singleton_method(:new, Object.method(:new))

    class_name ? const_set(class_name.to_s, struct_class) : struct_class
  end

  def dig(*args)
    to_h.dig(*args)
  end

  def values_at(*keys)
    values.values_at(*keys)
  end

  def each_pair(&block)
    to_h.each_pair(&block)
  end

  def each(&block)
    values.each(&block)
  end

  def select(&block)
    values.select(&block)
  end

  def ==(other)
    (other.class == self.class) && (values == other.values)
  end

  def eql?(other)
    (other.class == self.class) && (values.eql? other.values)
  end

  def hash 
    values.hash
  end
end

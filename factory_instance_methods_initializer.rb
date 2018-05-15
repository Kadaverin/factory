#
# initializer for Factory instance (it's a class)
# Create all methods like valuas_at, select and other
#
class FactoryInstanceMethodsInitializer < Module
  def initialize(*attributes)
    super() do
      attr_accessor(*attributes)

      define_method :initialize do |*values|
        values.each_with_index { |val, i| send("#{attributes[i]}=", val) }
      end

      define_method(:length) { attributes.length }

      define_method(:members) { attributes }

      define_method(:to_a) { attributes.map { |attr| send(attr) } }

      define_method(:to_h) { attributes.zip(values).to_h }

      define_method(:each) { |&block| values.each(&block) }

      define_method(:each_pair) { |&block| to_h.each_pair(&block) }

      define_method(:select) { |&block| values.select(&block) }

      define_method(:dig) { |*args| to_h.dig(*args) }

      define_method :== do |other|
        (other.is_a? struct_class) && (values == other.values)
      end

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

      define_method :values_at do |*keys|
        result = []

        keys.each do |key|
          case key.class.name
          when 'Integer' then result << self[key]
          when 'Range' then key.to_a.each { |i| result << self[i] }
          else raise ArgumentError
          end
        end
        result
      end

      define_method :[]= do |key, value|
        case key.class.name

        when 'String', 'Symbol'
          raise NameError unless attributes.include? key
          send("#{key}=", value)

        when 'Integer'
          raise IndexError if key.abs > attributes.length - 1
          send("#{attributes[key]}=", value)
        end
      end

      alias_method :size, :length
      alias_method :values, :to_a
      alias_method :to_s, :inspect
    end
  end
end

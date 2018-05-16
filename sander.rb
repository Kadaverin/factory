
require_relative './factory'

p 'STRUCT'

Person = Struct.new(:name, :s)
d1 = Person.new('dave', 's')

p 'FACTORY'

Person2 = Factory.new(:name, :surname, :s, :f, :g, :r, :g) do 
    def hello
        p "Hello, I my name is #{self.name}"
    end
end

d2 = Person2.new('Dave', 'Hell', 'f', 'g', 'd', 'f', 'd')

d2.hello

Factory.new('Person3', :name, :surname)
d3 = Factory::Person3.new('name', 'surname')

# p d3
# p d3.class.ancestors

# p d2.class.ancestors

p d2.values_at(0..1, 2...3, 3, 5)

# d3[-1] = 'Modifed Dave'

# d3.each { |k| p k }
# d3.each_pair { |k, v| p "#{k} : #{v}" }
# def m (t, *args)
#     p t.values_at(*args)
# end
# ar = (1..100).to_a
# r1 = 1..3
# r2 = (4..5)
# r3 = (6..7)
# m( ar , r1, r2, r3 )

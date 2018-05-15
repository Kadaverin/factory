
require_relative './factory'

p 'STRUCT'

Person = Struct.new(:name, :s)
d1 = Person.new('dave', 's')
p d1

p 'FACTORY'

Person2 = Factory.new(:name, :surname)

d2 = Person2.new('Dave', 'Hell')

Factory.new('Person3', :name, :surname)
d3 = Factory::Person3.new('name', 'surname')

p d3
p d3.class.ancestors

p d2.class.ancestors

p d3.values_at(0..1)
d3[-1] = 'Modifed Dave'

d3.each { |k| p k }
d3.each_pair { |k, v| p "#{k} : #{v}" }

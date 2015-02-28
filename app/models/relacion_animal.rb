# == Schema Information
#
# Table name: relacion_animals
#
#  id         :integer         not null, primary key
#  animal1_id :integer
#  animal2_id :integer
#  relacion   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class RelacionAnimal < ActiveRecord::Base

validates_uniqueness_of :animal1_id, :scope => :animal2_id, :case_sensitive => false

validates :animal1_id, :presence => true

validates :animal2_id, :presence => true


	belongs_to :animal, :foreign_key=>'animal1_id'

	belongs_to :animal2, :class_name =>Animal, :foreign_key=>'animal2_id'

end



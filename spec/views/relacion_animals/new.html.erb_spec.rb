require 'spec_helper'

describe "relacion_animals/new" do
  before(:each) do
    assign(:relacion_animal, stub_model(RelacionAnimal,
      :animal1_id => 1,
      :animal2_id => 1,
      :relacion => 1
    ).as_new_record)
  end

  it "renders new relacion_animal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => relacion_animals_path, :method => "post" do
      assert_select "input#relacion_animal_animal1_id", :name => "relacion_animal[animal1_id]"
      assert_select "input#relacion_animal_animal2_id", :name => "relacion_animal[animal2_id]"
      assert_select "input#relacion_animal_relacion", :name => "relacion_animal[relacion]"
    end
  end
end
